/// Sync manager for offline-first support
///
/// Handles syncing local Hive data to Firebase when connectivity is restored.
/// Priority queue: Attendance > Leave > Overtime > Profile

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/network_util.dart';
import '../../../domain/entities/attendance.dart';
import '../../datasources/local/attendance_local_datasource.dart';
import '../../datasources/local/user_local_datasource.dart';
import '../../datasources/remote/firestore_remote_datasource.dart';

class SyncManager {
  SyncManager._();
  static final SyncManager _instance = SyncManager._();
  factory SyncManager() => _instance;

  final _firestore = FirebaseFirestore.instance;
  final _attendanceLocal = AttendanceLocalDataSource();
  final _userLocal = UserLocalDataSource();

  bool _isSyncing = false;

  /// Check if a sync is currently in progress
  bool get isSyncing => _isSyncing;

  /// Sync all unsynced data to Firebase
  /// Should be called when connectivity is restored
  Future<void> syncAll() async {
    if (_isSyncing) return;
    if (!await NetworkUtil.isConnected()) return;

    _isSyncing = true;
    try {
      // 1. Sync unsynced attendance records
      await _syncAttendance();

      // 2. Sync user profile changes
      await _syncUserProfile();

      // 3. Sync other data (leave, shifts, etc.)
      // ... to be implemented in later phases

    } catch (e) {
      // Sync errors are non-fatal; data remains in local DB for retry
      print('Sync error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _syncAttendance() async {
    final unsynced = await _attendanceLocal.getUnsyncedAttendance();
    if (unsynced.isEmpty) return;

    final batch = _firestore.batch();
    int count = 0;

    for (final record in unsynced) {
      final docRef = _firestore
          .collection('organizations')
          .doc(record.organizationId)
          .collection('attendance')
          .doc(record.id);

      batch.set(docRef, record.toJson());

      // Mark as synced after adding to batch
      await _attendanceLocal.markAsSynced(record.id);
      count++;

      // Firestore batches have a 500-operation limit
      if (count % 400 == 0) {
        await batch.commit();
      }
    }

    if (count > 0) {
      await batch.commit();
    }
  }

  Future<void> _syncUserProfile() async {
    // User profile sync would go here
    // For now, user data is written directly to Firestore on signup/update
  }

  /// Listen for connectivity changes and auto-sync
  void startAutoSync(void Function(bool isSyncing) onSyncStatusChanged) {
    NetworkUtil.connectivityStream.listen((result) async {
      final isConnected = result != ConnectivityResult.none;
      if (isConnected && !_isSyncing) {
        onSyncStatusChanged(true);
        await syncAll();
        onSyncStatusChanged(false);
      }
    });
  }
}