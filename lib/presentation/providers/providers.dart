/// Riverpod providers for all state management

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';
import '../../di/service_locator.dart';

// ============ Auth Providers ============

/// Current authenticated user (from local cache)
final currentUserProvider = FutureProvider<User?>((ref) async {
  return ServiceLocator.authRepository.getCurrentUser();
});

/// Authentication state - whether user is signed in
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ServiceLocator.authRepository.isAuthenticated;
});

/// Auth state stream for listening to changes
final authStateStreamProvider = StreamProvider<User?>((ref) {
  return ServiceLocator.authRepository.authStateChanges;
});

// ============ Organization Providers ============

/// Active organization (currently selected)
final activeOrganizationProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

// ============ Placeholder providers for future use ============

/// These will be implemented in later phases with real data
final myOrganizationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return [];
});

final attendanceStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  return {
    'total': 0,
    'present': 0,
    'late': 0,
    'absent': 0,
  };
});
