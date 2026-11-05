/// Auth repository contract

import '../../domain/entities/user.dart';

abstract class AuthRepository {
  /// Sign in with email and password
  Future<User> signIn({required String email, required String password});

  /// Sign up with email and password
  Future<User> signUp({
    required String email,
    required String password,
    required String displayName,
  });

  /// Sign in with Google
  Future<User> signInWithGoogle();

  /// Sign out
  Future<void> signOut();

  /// Get current authenticated user
  User? getCurrentUser();

  /// Stream of auth state changes
  Stream<User?> get authStateChanges;

  /// Check if user is authenticated
  bool get isAuthenticated;

  /// Register face data for a user (face registration)
  Future<void> registerFace({
    required String userId,
    required List<double> faceEmbedding,
    required String faceImageUrl,
  });

  /// Verify face against stored embedding
  Future<bool> verifyFace({
    required String userId,
    required List<double> liveEmbedding,
    required double threshold,
  });

  /// Get stored face embedding for a user
  Future<List<double>?> getFaceEmbedding(String userId);
}