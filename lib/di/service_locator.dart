/// Service Locator - Dependency Injection setup
///
/// Centralizes all repository instances and provides them to widgets.
/// Uses Riverpod's container for dependency injection.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/local/hive_service.dart';
import '../data/repositories/attendance_repository_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/face_repository_impl.dart';
import '../data/repositories/leave_repository_impl.dart';
import '../data/repositories/organization_repository_impl.dart';
import '../data/repositories/shift_repository_impl.dart';
import '../data/datasources/remote/sync_manager.dart';

class ServiceLocator {
  ServiceLocator._();
  static late final AuthRepositoryImpl authRepository = AuthRepositoryImpl();
  static late final OrganizationRepositoryImpl organizationRepository =
      OrganizationRepositoryImpl();
  static late final AttendanceRepositoryImpl attendanceRepository =
      AttendanceRepositoryImpl();
  static late final ShiftRepositoryImpl shiftRepository = ShiftRepositoryImpl();
  static late final LeaveRepositoryImpl leaveRepository = LeaveRepositoryImpl();
  static late final FaceRepositoryImpl faceRepository = FaceRepositoryImpl();
  static late final HiveService hiveService = HiveService();
  static late final SyncManager syncManager = SyncManager();
}

final providerContainer = ProviderContainer();
