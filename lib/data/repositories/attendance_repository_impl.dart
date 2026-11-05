/// Attendance repository implementation

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/attendance.dart';
import '../../../domain/repositories/attendance_repository.dart';
import '../datasources/local/attendance_local_datasource.dart';
import '../datasources/remote/firestore_remote_datasource.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  AttendanceRepositoryImpl._();
  static final AttendanceRepositoryImpl _instance = AttendanceRepositoryImpl._();
  factory AttendanceRepositoryImpl() => _instance;

  final _remote = FirestoreRemoteDataSource();
  final _local = AttendanceLocalDataSource();

  @override
  Future<Attendance> checkIn({
    required String userId,
    required String organizationId,
    required double latitude,
    required double longitude,
    required String locationName,
    required bool faceVerified,
    required double faceConfidence,
    required double faceMatchScore,
    String? shiftId,
  }) async {
    // Try remote first
    try {
      final record = await _remote.createAttendanceRecord(
        userId: userId,
        organizationId: organizationId,
        type: AttendanceType.checkIn,
        status: AttendanceStatus.pending,
        timestamp: DateTime.now(),
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
        faceVerified: faceVerified,
        faceConfidence: faceConfidence,
        faceMatchScore: faceMatchScore,
        shiftId: shiftId,
        notes: 'Face scan verified',
      );
      // Cache locally
      await _local.saveAttendance(record);
      return record;
    } catch (e) {
      // Offline - save locally first, sync later
      final record = Attendance(
        id: '${DateTime.now().millisecondsSinceEpoch}_$userId',
        userId: userId,
        organizationId: organizationId,
        type: AttendanceType.checkIn,
        status: AttendanceStatus.pending,
        timestamp: DateTime.now(),
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
        faceVerified: faceVerified,
        faceConfidence: faceConfidence,
        faceMatchScore: faceMatchScore,
        shiftId: shiftId,
        notes: 'Face scan verified (offline)',
        createdAt: DateTime.now(),
        isSynced: false,
      );
      await _local.saveAttendance(record);
      return record;
    }
  }

  @override
  Future<Attendance> checkOut({
    required String userId,
    required String organizationId,
    required double latitude,
    required double longitude,
    required String locationName,
    required bool faceVerified,
    required double faceConfidence,
    required double faceMatchScore,
  }) async {
    try {
      final record = await _remote.createAttendanceRecord(
        userId: userId,
        organizationId: organizationId,
        type: AttendanceType.checkOut,
        status: AttendanceStatus.pending,
        timestamp: DateTime.now(),
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
        faceVerified: faceVerified,
        faceConfidence: faceConfidence,
        faceMatchScore: faceMatchScore,
      );
      await _local.saveAttendance(record);
      return record;
    } catch (e) {
      final record = Attendance(
        id: '${DateTime.now().millisecondsSinceEpoch}_$userId',
        userId: userId,
        organizationId: organizationId,
        type: AttendanceType.checkOut,
        status: AttendanceStatus.pending,
        timestamp: DateTime.now(),
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
        faceVerified: faceVerified,
        faceConfidence: faceConfidence,
        faceMatchScore: faceMatchScore,
        createdAt: DateTime.now(),
        isSynced: false,
      );
      await _local.saveAttendance(record);
      return record;
    }
  }

  @override
  Future<Attendance> startBreak({
    required String userId,
    required String organizationId,
  }) async {
    try {
      final record = await _remote.createAttendanceRecord(
        userId: userId,
        organizationId: organizationId,
        type: AttendanceType.breakStart,
        status: AttendanceStatus.pending,
        timestamp: DateTime.now(),
        latitude: 0.0,
        longitude: 0.0,
        locationName: 'Break',
        faceVerified: false,
        faceConfidence: 0.0,
        faceMatchScore: 0.0,
      );
      await _local.saveAttendance(record);
      return record;
    } catch (e) {
      final record = Attendance(
        id: '${DateTime.now().millisecondsSinceEpoch}_$userId',
        userId: userId,
        organizationId: organizationId,
        type: AttendanceType.breakStart,
        status: AttendanceStatus.pending,
        timestamp: DateTime.now(),
        latitude: 0.0,
        longitude: 0.0,
        locationName: 'Break',
        faceVerified: false,
        faceConfidence: 0.0,
        faceMatchScore: 0.0,
        createdAt: DateTime.now(),
        isSynced: false,
      );
      await _local.saveAttendance(record);
      return record;
    }
  }

  @override
  Future<Attendance> endBreak({
    required String userId,
    required String organizationId,
  }) async {
    try {
      final record = await _remote.createAttendanceRecord(
        userId: userId,
        organizationId: organizationId,
        type: AttendanceType.breakEnd,
        status: AttendanceStatus.pending,
        timestamp: DateTime.now(),
        latitude: 0.0,
        longitude: 0.0,
        locationName: 'Break End',
        faceVerified: false,
        faceConfidence: 0.0,
        faceMatchScore: 0.0,
      );
      await _local.saveAttendance(record);
      return record;
    } catch (e) {
      final record = Attendance(
        id: '${DateTime.now().millisecondsSinceEpoch}_$userId',
        userId: userId,
        organizationId: organizationId,
        type: AttendanceType.breakEnd,
        status: AttendanceStatus.pending,
        timestamp: DateTime.now(),
        latitude: 0.0,
        longitude: 0.0,
        locationName: 'Break End',
        faceVerified: false,
        faceConfidence: 0.0,
        faceMatchScore: 0.0,
        createdAt: DateTime.now(),
        isSynced: false,
      );
      await _local.saveAttendance(record);
      return record;
    }
  }

  @override
  Future<Attendance> startOvertime({
    required String userId,
    required String organizationId,
  }) async {
    try {
      final record = await _remote.createAttendanceRecord(
        userId: userId,
        organizationId: organizationId,
        type: AttendanceType.overtimeStart,
        status: AttendanceStatus.pending,
        timestamp: DateTime.now(),
        latitude: 0.0,
        longitude: 0.0,
        locationName: 'Overtime',
        faceVerified: false,
        faceConfidence: 0.0,
        faceMatchScore: 0.0,
      );
      await _local.saveAttendance(record);
      return record;
    } catch (e) {
      final record = Attendance(
        id: '${DateTime.now().millisecondsSinceEpoch}_$userId',
        userId: userId,
        organizationId: organizationId,
        type: AttendanceType.overtimeStart,
        status: AttendanceStatus.pending,
        timestamp: DateTime.now(),
        latitude: 0.0,
        longitude: 0.0,
        locationName: 'Overtime',
        faceVerified: false,
        faceConfidence: 0.0,
        faceMatchScore: 0.0,
        createdAt: DateTime.now(),
        isSynced: false,
      );
      await _local.saveAttendance(record);
      return record;
    }
  }

  @override
  Future<Attendance> endOvertime({
    required String userId,
    required String organizationId,
  }) async {
    try {
      final record = await _remote.createAttendanceRecord(
        userId: userId,
        organizationId: organizationId,
        type: AttendanceType.overtimeEnd,
        status: AttendanceStatus.pending,
        timestamp: DateTime.now(),
        latitude: 0.0,
        longitude: 0.0,
        locationName: 'Overtime End',
        faceVerified: false,
        faceConfidence: 0.0,
        faceMatchScore: 0.0,
      );
      await _local.saveAttendance(record);
      return record;
    } catch (e) {
      final record = Attendance(
        id: '${DateTime.now().millisecondsSinceEpoch}_$userId',
        userId: userId,
        organizationId: organizationId,
        type: AttendanceType.overtimeEnd,
        status: AttendanceStatus.pending,
        timestamp: DateTime.now(),
        latitude: 0.0,
        longitude: 0.0,
        locationName: 'Overtime End',
        faceVerified: false,
        faceConfidence: 0.0,
        faceMatchScore: 0.0,
        createdAt: DateTime.now(),
        isSynced: false,
      );
      await _local.saveAttendance(record);
      return record;
    }
  }

  @override
  Future<List<Attendance>> getAttendanceHistory({
    required String organizationId,
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final remote = await _remote.getAttendanceHistory(
        organizationId: organizationId,
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
      // Cache locally
      for (final record in remote) {
        await _local.saveAttendance(record);
      }
      return remote;
    } catch (e) {
      // Fall back to local
      return await _local.getAttendance(
        organizationId: organizationId,
        userId: userId,
      );
    }
  }

  @override
  Future<List<Attendance>> getOrganizationAttendance({
    required String organizationId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _remote.getOrganizationAttendance(
      organizationId: organizationId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<void> approveAttendance({
    required String attendanceId,
    required String organizationId,
    required bool approved,
    required String approvedBy,
    String? notes,
  }) async {
    await _remote.approveAttendance(
      attendanceId: attendanceId,
      organizationId: organizationId,
      approved: approved,
      approvedBy: approvedBy,
      notes: notes,
    );
  }

  @override
  Future<List<Attendance>> getUnsyncedAttendance() async {
    return await _local.getUnsyncedAttendance();
  }

  @override
  Future<void> markAsSynced(String attendanceId) async {
    await _local.markAsSynced(attendanceId);
  }

  @override
  Stream<List<Attendance>> watchAttendance(String organizationId) {
    return _remote.watchAttendance(organizationId);
  }
}