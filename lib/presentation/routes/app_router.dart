/// GoRouter configuration with authentication guards

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../di/service_locator.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/organization/org_selection_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/attendance/attend_screen.dart';

class AppRouter {
  AppRouter._();

  static GoRouter router(BuildContext context) {
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(
        ServiceLocator.authRepository.authStateChanges,
      ),
      redirect: (context, state) {
        final isAuthenticated = ServiceLocator.authRepository.isAuthenticated;
        final loggingIn = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        if (!isAuthenticated) {
          if (loggingIn) return null;
          return '/login';
        }

        // User is authenticated, redirect away from login/register
        if (loggingIn) return '/org-selection';

        return null; // let the route proceed
      },
      routes: [
        // Auth routes
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        // Face registration
        GoRoute(
          path: '/face-registration',
          builder: (context, state) => const FaceRegistrationScreen(),
        ),
        // App routes (require auth)
        GoRoute(
          path: '/org-selection',
          builder: (context, state) => const OrgSelectionScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/attend',
          builder: (context, state) {
            final actionString = state.queryParams['action'] ?? 'check_in';
            final action = AttendanceAction.values.firstWhere(
              (e) => e.name == actionString,
              orElse: () => AttendanceAction.checkIn,
            );
            return AttendScreen(action: action);
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
      ],
    );
  }
}

/// Placeholder face registration screen - uses camera + ML Kit
class FaceRegistrationScreen extends StatefulWidget {
  const FaceRegistrationScreen({super.key});

  @override
  State<FaceRegistrationScreen> createState() => _FaceRegistrationScreenState();
}

class _FaceRegistrationScreenState extends State<FaceRegistrationScreen> {
  CameraController? _cameraController;
  FaceDetector? _faceDetector;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  int _currentAngleIndex = 0;
  final List<String> _angleNames = [
    'Depan (Front)',
    'Kiri (Left)',
    'Kanan (Right)',
    'Atas (Up)',
    'Bawah (Down)',
  ];
  final List<File> _capturedImages = [];
  final List<List<double>> _embeddings = [];
  bool _isProcessing = false;
  bool _registrationComplete = false;

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
      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector?.close();
    super.dispose();
  }

  Future<void> _captureFace() async {
    if (_isCapturing || _currentAngleIndex >= AppConstants.faceRegistrationAngles) return;

    setState(() => _isCapturing = true);

    try {
      final xFile = await _cameraController!.takePicture();
      final file = File(xFile.path);

      // Detect face in the captured image
      final inputImage = InputImage.fromFilePath(xFile.path);
      final faces = await _faceDetector!.processImage(inputImage);

      if (faces.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Wajah tidak terdeteksi. Silakan coba lagi.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Save captured image
      _capturedImages.add(file);

      // Extract embedding (simplified - using face detection confidence as proxy)
      final face = faces.first;
      final embedding = _extractMockEmbedding(face);
      _embeddings.add(embedding);

      setState(() {
        _currentAngleIndex++;
      });

      if (_currentAngleIndex >= AppConstants.faceRegistrationAngles) {
        await _completeRegistration();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Capture failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  /// Extract a mock 128-d embedding from face detection
  /// In production, replace with MobileFaceNet TFLite model inference
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

  Future<void> _completeRegistration() async {
    setState(() => _isProcessing = true);

    try {
      final averagedEmbedding = _averageEmbeddings(_embeddings);

      final currentUser = await ServiceLocator.authRepository.getCurrentUser();
      if (currentUser == null) throw Exception('User not authenticated');

      await ServiceLocator.authRepository.registerFace(
        userId: currentUser.id,
        faceEmbedding: averagedEmbedding,
        faceImageUrl: '',
      );

      if (mounted) {
        setState(() => _registrationComplete = true);
      }

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        context.go('/org-selection');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  List<double> _averageEmbeddings(List<List<double>> embeddings) {
    if (embeddings.isEmpty) return List<double>.filled(128, 0.0);
    final averaged = List<double>.filled(128, 0.0);
    for (int i = 0; i < 128; i++) {
      double sum = 0;
      for (final emb in embeddings) {
        sum += emb[i];
      }
      averaged[i] = sum / embeddings.length;
    }
    return averaged;
  }

  Widget _buildAngleGuide() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Posisi Wajah',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_angleNames[_currentAngleIndex]} (${_currentAngleIndex + 1}/${AppConstants.faceRegistrationAngles})',
            style: const TextStyle(
              color: Color(0xFF2563EB),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (_currentAngleIndex + 1) / AppConstants.faceRegistrationAngles,
            backgroundColor: Colors.white24,
            color: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_registrationComplete) {
      return Scaffold(
        backgroundColor: const Color(0xFF090D14),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 80,
                color: Color(0xFF10B981),
              ),
              const SizedBox(height: 24),
              const Text(
                'Wajah Terdaftar!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selamat, wajah Anda telah terdaftar untuk absensi.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF090D14),
      body: Stack(
        children: [
          // Camera Preview
          CameraPreview(_cameraController!),

          // Overlay - Face Guide
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.face_rounded,
                  size: 80,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),

          // Angle Guide
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: _buildAngleGuide(),
          ),

          // Capture Button
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt_rounded,
                      color: Colors.white, size: 28),
                  onPressed: _isCapturing ? null : _captureFace,
                ),
              ),
            ),
          ),

          // Processing overlay
          if (_isProcessing)
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Memproses pendaftaran wajah...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Stream to refresh router when auth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
