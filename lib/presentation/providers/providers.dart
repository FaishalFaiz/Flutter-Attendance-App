/// Riverpod providers for all state management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/app_exception.dart';
import '../../data/datasources/local/hive_service.dart';
import '../../domain/entities/organization.dart';
import '../../domain/entities/organization_member.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/face_repository.dart';
import '../../domain/repositories/leave_repository.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../domain/repositories/organization_repository.dart';
import '../../domain/repositories/shift_repository.dart';
import '../di/service_locator.dart';

// ============ Auth Providers ============

/// Current authenticated user
final authUserProvider = FutureProvider<User?>((ref) async {
  return ServiceLocator.authRepository.getCurrentUser();
});

/// Authentication state stream (changes trigger UI rebuilds)
final authStateProvider = StreamProvider<bool>((ref) async* {
  yield await ServiceLocator.authRepository.isAuthenticated;
  yield* ServiceLocator.authRepository.authStateChanges.asyncMap(
    (user) => user != null,
  );
});

/// Sign in with email/password
FutureProviderFamily<AuthResult, AuthRequest> _signInProvider;

class AuthResult {
  final bool success;
  final String? error;
  final User? user;
  const AuthResult({this.success = false, this.error, this.user});
}

class AuthRequest {
  final String email;
  final String password;
  const AuthRequest({required this.email, required this.password});
}

/// Sign in family provider (by auth request params)
final signInProvider = Provider<SignInFn>((ref) => ref.watch(serviceLocatorProvider));

typedef SignInFn = Future<User> Function({
  String email,
  String password,
});

// ============ Organization Providers ============

/// List of organizations the current user belongs to
final myOrganizationsProvider =
    StreamProvider<List<Organization>>((ref) async* {
  yield await ServiceLocator.organizationRepository.getMyOrganizations();
  yield* ServiceLocator.organizationRepository.watchMyOrganizations();
});

/// Active organization (last joined)
final activeOrganizationProvider = StateProvider<Organization?>((ref) {
  return null;
});

/// Organization members stream
final orgMembersProvider =
    StreamProvider.family<List<OrganizationMember>, String>((ref, orgId) {
  return ServiceLocator.organizationRepository.watchMembers(orgId);
});

// ============ Attendance Providers ============

/// Current attendance data for active organization (from Firestore stream)
final attendanceStreamProvider =
    StreamProvider.family<List<dynamic>, String>((ref, orgId) {
  return ServiceLocator.attendanceRepository.watchAttendance(orgId);
});

/// Shift data for active organization
final shiftsProvider =
    StreamProvider.family<List<dynamic>, String>((ref, orgId) {
  return ServiceLocator.shiftRepository.watchShifts(orgId);
});

/// Unsynced offline records count
final unsyncedCountProvider = FutureProvider<int>((ref) async {
  return await ServiceLocator.attendanceRepository.getUnsyncedAttendance().then((records) => records.length);
});

// ============ Favorites / Settings ============

/// Widgets that need access to multiple repositories can use `ref.read()` here.
