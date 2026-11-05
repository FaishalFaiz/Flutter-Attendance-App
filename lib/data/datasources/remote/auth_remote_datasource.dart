/// Remote datasource for authentication (Firebase Auth)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../domain/entities/user.dart' as domain_user;

class AuthRemoteDataSource {
  AuthRemoteDataSource._();
  static final AuthRemoteDataSource _instance = AuthRemoteDataSource._();
  factory AuthRemoteDataSource() => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Convert Firebase User to domain User
  Future<domain_user.User> _toDomainUser(UserCredential credential) async {
    final firebaseUser = credential.user!;
    final doc = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (doc.exists) {
      return domain_user.User.fromJson(doc.data()!);
    } else {
      // Create user record in Firestore
      final newUser = domain_user.User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? firebaseUser.email?.split('@').first ?? 'User',
        photoUrl: firebaseUser.photoURL,
        authProvider: credential.credential?.providerId ?? 'email',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(firebaseUser.uid).set(newUser.toJson());
      return newUser;
    }
  }

  /// Sign in with email and password
  Future<domain_user.User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await _toDomainUser(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
      );
    }
  }

  /// Sign up with email and password
  Future<domain_user.User> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(displayName);
      return await _toDomainUser(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException(message: 'Failed to sign out: $e');
    }
  }

  /// Get current authenticated user
  domain_user.User? getCurrentUser() {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    return domain_user.User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? 'User',
      photoUrl: firebaseUser.photoURL,
      authProvider: 'email',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Stream of auth state changes
  Stream<domain_user.User?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      try {
        final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (doc.exists) {
          return domain_user.User.fromJson(doc.data()!);
        }
      } catch (_) {}
      return domain_user.User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? 'User',
        photoUrl: firebaseUser.photoURL,
        authProvider: 'email',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'User not found. Please check your email.';
      case 'wrong-password':
        return 'Wrong password. Please try again.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return 'Authentication failed: $code';
    }
  }
}
