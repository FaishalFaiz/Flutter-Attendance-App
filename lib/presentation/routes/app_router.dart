/// GoRouter configuration with authentication guards

import 'dart:async';

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

/// Placeholder face registration screen
class FaceRegistrationScreen extends StatelessWidget {
  const FaceRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D14),
      appBar: AppBar(
        title: const Text('Face Registration'),
        backgroundColor: const Color(0xFF111722),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.face_rounded, size: 80, color: Colors.white24),
            const SizedBox(height: 24),
            const Text(
              'Face Registration',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Register your face for biometric attendance',
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Capture Face'),
              ),
            ),
          ],
        ),
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
