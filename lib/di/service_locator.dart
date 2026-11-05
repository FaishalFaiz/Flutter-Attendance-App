/// Service Locator - Dependency Injection setup
///
/// Centralizes all repository instances and provides them to widgets.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/local/hive_service.dart';
import '../data/repositories/attendance_repository_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/face_repository_impl.dart';
import '../data/repositories/leave_repository_impl.dart';
import '../data/repositories/organization_repository_impl.dart';
import '../data/repositories/shift_repository_impl.dart';
import '../data/datasources/remote/sync_manager.dart';
import 'seed_demo_data.dart';

class ServiceLocator {
  ServiceLocator._();
  static final AuthRepositoryImpl authRepository = AuthRepositoryImpl();
  static final OrganizationRepositoryImpl organizationRepository =
      OrganizationRepositoryImpl();
  static final AttendanceRepositoryImpl attendanceRepository =
      AttendanceRepositoryImpl();
  static final ShiftRepositoryImpl shiftRepository = ShiftRepositoryImpl();
  static final LeaveRepositoryImpl leaveRepository = LeaveRepositoryImpl();
  static final FaceRepositoryImpl faceRepository = FaceRepositoryImpl();
  static final HiveService hiveService = HiveService();
  static final SyncManager syncManager = SyncManager();
}

final providerContainer = ProviderContainer();
