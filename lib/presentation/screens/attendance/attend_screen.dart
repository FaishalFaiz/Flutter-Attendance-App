/// Attendance Screen - Face verification + Check In/Out/Break/Overtime

import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/repositories/attendance_repository_impl.dart';
import '../../../di/service_locator.dart';
import '../../routes/app_router.dart';

enum AttendanceAction { checkIn, checkOut, breakStart, breakEnd, overtimeStart, overtimeEnd }

class AttendScreen extends StatefulWidget {
  final AttendanceAction action;

  const AttendScreen({super.key, this.action = AttendanceAction.checkIn});

  @override
  State<AttendScreen> createState() => _AttendScreenState();
}

class _AttendScreenState extends State<AttendScreen> {
  CameraController? _cameraController;
  FaceDetector? _faceDetector;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isVerifying = false;
  bool _faceDetected = false;
  bool _faceVerified = false;
  bool _isSubmitting = false;
  double _matchConfidence = 0.0;
  String _locationName = 'Mengambil lokasi...';
  String _verificationMessage = 'Posisikan wajah di depan kamera';

  final _attendanceRepo = AttendanceRepositoryImpl();

  @override
  void initState() {
    super.initState();
    _initCamera();
    _faceDetector = GoogleMlKit.vision.faceDetector(
      const FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
        enableLandmarks: true,
        enableClassification: true,
        minFaceSize: 0.12,
      ),
    );
    _loadLocation();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      final frontCamera = _cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _cameraController!.startImageStream(_processCameraImage);

      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCameraInitialized = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera error: $e')),
        );
      }
    }
  }

  Future<void> _loadLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _locationName = 'GPS tidak aktif');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => _locationName = 'Izin GPS ditolak');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        setState(() {
          _locationName = '${p.street ?? ''}, ${p.locality ?? ''}';
        });
      } else {
        setState(() {
          _locationName =
              'Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}';
        });
      }
    } catch (e) {
      setState(() => _locationName = 'Lokasi tidak tersedia');
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isVerifying) return;
    final controller = _cameraController;
    if (controller == null || !controller.value.isStreamingImages) return;
    final detector = _faceDetector;
    if (detector == null) return;

    try {
      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null) return;

      final rotation = InputImageRotationValue.fromRawValue(
        controller.description.sensorOrientation,
      );
      if (rotation == null) return;

      final inputImage = InputImage.fromBytes(
        bytes: image.planes.first.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );

      final faces = await detector.processImage(inputImage);
      final detected = faces.isNotEmpty;

      if (mounted && detected != _faceDetected) {
        setState(() {
          _faceDetected = detected;
          _verificationMessage =
              detected ? 'Wajah terdeteksi' : 'Wajah tidak terdeteksi';
        });
      }
    } catch (_) {
      // Ignore transient frame processing errors
    }
  }

  Future<void> _verifyAndSubmit() async {
    if (!_faceDetected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wajah tidak terdeteksi di depan kamera.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
      _isSubmitting = true;
    });

    try {
      // Capture image
      final xFile = await _cameraController!.takePicture();
      final file = File(xFile.path);
      final imageBytes = await file.readAsBytes();

      // Verify face against stored embedding
      final currentUser = await ServiceLocator.authRepository.getCurrentUser();
      if (currentUser == null) throw Exception('User not authenticated');

      final storedEmbedding =
          await ServiceLocator.faceRepository.getFaceEmbedding(currentUser.id);

      bool isMatch = false;
      double confidence = 0.0;

      if (storedEmbedding != null && storedEmbedding.isNotEmpty) {
        // Generate mock embedding from captured image (in production, use MobileFaceNet)
        final inputImage = InputImage.fromFilePath(xFile.path);
        final faces = await _faceDetector!.processImage(inputImage);
        if (faces.isNotEmpty) {
          final face = faces.first;
          final liveEmbedding = _extractMockEmbedding(face);
          confidence = _cosineSimilarity(liveEmbedding, storedEmbedding);
          isMatch = confidence >= AppConstants.defaultFaceThreshold;
        }
      } else {
        // No face registered yet - allow but warn
        isMatch = true;
        confidence = 0.5;
      }

      if (!isMatch) {
        setState(() {
          _isVerifying = false;
          _isSubmitting = false;
          _faceVerified = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Wajah tidak cocok (confidence: ${(confidence * 100).toStringAsFixed(0)}%).',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      setState(() {
        _faceVerified = true;
        _matchConfidence = confidence;
        _verificationMessage = 'Wajah terverifikasi (${(confidence * 100).toStringAsFixed(0)}%)';
      });

      // Submit attendance
      await _submitAttendance(
        faceVerified: true,
        faceConfidence: confidence,
        faceMatchScore: confidence,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.action} berhasil dicatat!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _submitAttendance({
    required bool faceVerified,
    required double faceConfidence,
    required double faceMatchScore,
  }) async {
    final currentUser = await ServiceLocator.authRepository.getCurrentUser();
    if (currentUser == null) return;

    // Get active org from local storage or use demo
    final orgId = 'demo_org_001'; // TODO: Get from active org provider

    final now = DateTime.now();

    switch (widget.action) {
      case AttendanceAction.checkIn:
        await _attendanceRepo.checkIn(
          userId: currentUser.id,
          organizationId: orgId,
          latitude: 0.0, // TODO: Get from location
          longitude: 0.0,
          locationName: _locationName,
          faceVerified: faceVerified,
          faceConfidence: faceConfidence,
          faceMatchScore: faceMatchScore,
        );
        break;
      case AttendanceAction.checkOut:
        await _attendanceRepo.checkOut(
          userId: currentUser.id,
          organizationId: orgId,
          latitude: 0.0,
          longitude: 0.0,
          locationName: _locationName,
          faceVerified: faceVerified,
          faceConfidence: faceConfidence,
          faceMatchScore: faceMatchScore,
        );
        break;
      case AttendanceAction.breakStart:
        await _attendanceRepo.startBreak(
          userId: currentUser.id,
          organizationId: orgId,
        );
        break;
      case AttendanceAction.breakEnd:
        await _attendanceRepo.endBreak(
          userId: currentUser.id,
          organizationId: orgId,
        );
        break;
      case AttendanceAction.overtimeStart:
        await _attendanceRepo.startOvertime(
          userId: currentUser.id,
          organizationId: orgId,
        );
        break;
      case AttendanceAction.overtimeEnd:
        await _attendanceRepo.endOvertime(
          userId: currentUser.id,
          organizationId: orgId,
        );
        break;
    }
  }

  /// Extract mock embedding from face detection
  List<double> _extractMockEmbedding(Face face) {
    final embedding = List<double>.filled(128, 0.0);
    final seed = (face.headEulerAngleZ ?? 0).round() +
        ((face.leftEyeOpenProbability ?? 1) * 100).round() +
        ((face.rightEyeOpenProbability ?? 1) * 100).round();
    for (int i = 0; i < 128; i++) {
      embedding[i] = ((seed + i * 7) % 100) / 100.0;
    }
    return embedding;
  }

  double _cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) return 0.0;
    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;
    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    if (normA == 0.0 || normB == 0.0) return 0.0;
    return dotProduct / (normA * normB);
  }

  String _getActionTitle() {
    switch (widget.action) {
      case AttendanceAction.checkIn: return 'Check In';
      case AttendanceAction.checkOut: return 'Check Out';
      case AttendanceAction.breakStart: return 'Mulai Istirahat';
      case AttendanceAction.breakEnd: return 'Selesai Istirahat';
      case AttendanceAction.overtimeStart: return 'Mulai Lembur';
      case AttendanceAction.overtimeEnd: return 'Selesai Lembur';
    }
  }

  IconData _getActionIcon() {
    switch (widget.action) {
      case AttendanceAction.checkIn: return Icons.login_rounded;
      case AttendanceAction.checkOut: return Icons.logout_rounded;
      case AttendanceAction.breakStart: return Icons.pause_rounded;
      case AttendanceAction.breakEnd: return Icons.play_arrow_rounded;
      case AttendanceAction.overtimeStart: return Icons.schedule_rounded;
      case AttendanceAction.overtimeEnd: return Icons.schedule_rounded;
    }
  }

  Color _getActionColor() {
    switch (widget.action) {
      case AttendanceAction.checkIn: return const Color(0xFF10B981);
      case AttendanceAction.checkOut: return const Color(0xFFEF4444);
      case AttendanceAction.breakStart: return const Color(0xFFF59E0B);
      case AttendanceAction.breakEnd: return const Color(0xFFF59E0B);
      case AttendanceAction.overtimeStart: return const Color(0xFF8B5CF6);
      case AttendanceAction.overtimeEnd: return const Color(0xFF8B5CF6);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B12),
      body: Stack(
        children: [
          if (_isCameraInitialized)
            CameraPreview(_cameraController!)
          else
            const Center(child: CircularProgressIndicator()),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_getActionIcon(),
                                color: _getActionColor(), size: 16),
                            const SizedBox(width: 6),
                            Text(
                              _getActionTitle().toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded,
                            color: Colors.white),
                        onPressed: _initCamera,
                      ),
                    ],
                  ),
                ),

                // Location + Time
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          color: Colors.white70, size: 14),
                      const SizedBox(width: 6),
                      StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)),
                        builder: (context, snapshot) => Text(
                          DateFormat('HH:mm:ss').format(DateTime.now()),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on_rounded,
                          color: Color(0xFF2563EB), size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _locationName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Face Detection Status Pill
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _faceDetected
                            ? Colors.green.withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _faceDetected ? Colors.green : Colors.amber,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _faceDetected ? 'Wajah Terdeteksi' : 'Pindai Wajah',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Verification Status
                if (_faceVerified)
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Colors.green.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded,
                            color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Terverifikasi (${(_matchConfidence * 100).toStringAsFixed(0)}%)',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Action Button
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isSubmitting || !_faceDetected
                          ? null
                          : _verifyAndSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _faceDetected
                            ? _getActionColor()
                            : Colors.white.withValues(alpha: 0.2),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.white
                            .withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: _faceDetected ? 8 : 0,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _faceDetected ? 'SCAN & SIMPAN' : 'SCAN WAJAH',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
