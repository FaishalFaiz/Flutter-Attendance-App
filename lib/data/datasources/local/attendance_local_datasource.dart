/// Local datasource for attendance data (Hive)

import 'package:hive/hive.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../domain/entities/attendance.dart';
import '../../datasources/local/hive_service.dart';

class AttendanceLocalDataSource {
  AttendanceLocalDataSource._();
  static final AttendanceLocalDataSource _instance = AttendanceLocalDataSource._();
  factory AttendanceLocalDataSource() => _instance;

  Future<void> saveAttendance(Attendance attendance) async {
    try {
      final box = HiveService().attendanceBox;
      await box.put(attendance.id, attendance);
    } catch (e) {
      throw LocalStorageException(message: 'Failed to save attendance: $e');
    }
  }

  Future<List<Attendance>> getAttendance({
    required String organizationId,
    required String userId,
  }) async {
    try {
      final box = HiveService().attendanceBox;
      return box.values
          .where((a) => a.organizationId == organizationId && a.userId == userId)
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      throw LocalStorageException(message: 'Failed to get attendance: $e');
    }
  }

  Future<List<Attendance>> getUnsyncedAttendance() async {
    try {
      final box = HiveService().attendanceBox;
      return box.values.where((a) => !a.isSynced).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } catch (e) {
      throw LocalStorageException(message: 'Failed to get unsynced attendance: $e');
    }
  }

  Future<void> markAsSynced(String attendanceId) async {
    try {
      final box = HiveService().attendanceBox;
      final attendance = box.get(attendanceId);
      if (attendance != null) {
        await box.put(attendanceId, attendance.copyWith(isSynced: true, syncedAt: DateTime.now()));
      }
    } catch (e) {
      throw LocalStorageException(message: 'Failed to mark attendance as synced: $e');
    }
  }

  Future<void> deleteAttendance(String id) async {
    try {
      final box = HiveService().attendanceBox;
      await box.delete(id);
    } catch (e) {
      throw LocalStorageException(message: 'Failed to delete attendance: $e');
    }
  }

  Future<void> clearAllAttendance() async {
    try {
      final box = HiveService().attendanceBox;
      await box.clear();
    } catch (e) {
      throw LocalStorageException(message: 'Failed to clear attendance: $e');
    }
  }
}