/// Attendance repository contract

import '../entities/attendance.dart';

abstract class AttendanceRepository {
  /// Check in
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
  });

  /// Check out
  Future<Attendance> checkOut({
    required String userId,
    required String organizationId,
    required double latitude,
    required double longitude,
    required String locationName,
    required bool faceVerified,
    required double faceConfidence,
    required double faceMatchScore,
  });

  /// Start break
  Future<Attendance> startBreak({
    required String userId,
    required String organizationId,
  });

  /// End break
  Future<Attendance> endBreak({
    required String userId,
    required String organizationId,
  });

  /// Start overtime
  Future<Attendance> startOvertime({
    required String userId,
    required String organizationId,
  });

  /// End overtime
  Future<Attendance> endOvertime({
    required String userId,
    required String organizationId,
  });

  /// Get attendance history for a user in an organization
  Future<List<Attendance>> getAttendanceHistory({
    required String organizationId,
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get all attendance for an organization (admin view)
  Future<List<Attendance>> getOrganizationAttendance({
    required String organizationId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Approve or reject attendance (admin)
  Future<void> approveAttendance({
    required String attendanceId,
    required String organizationId,
    required bool approved,
    required String approvedBy,
    String? notes,
  });

  /// Get unsynced attendance records (offline)
  Future<List<Attendance>> getUnsyncedAttendance();

  /// Mark attendance as synced
  Future<void> markAsSynced(String attendanceId);

  /// Stream of attendance records (real-time)
  Stream<List<Attendance>> watchAttendance(String organizationId);
}