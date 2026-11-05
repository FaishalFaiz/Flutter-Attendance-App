/// Auth repository implementation

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/encryption_util.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../datasources/local/user_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl._();
  static final AuthRepositoryImpl _instance = AuthRepositoryImpl._();
  factory AuthRepositoryImpl() => _instance;

  final _remote = AuthRemoteDataSource();
  final _local = UserLocalDataSource();
  final _secureStorage = const FlutterSecureStorage();

  @override
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    final user = await _remote.signIn(email: email, password: password);
    await _local.saveCurrentUser(user);
    await _local.saveUser(user);
    await _secureStorage.write(
      key: 'auth_token',
      value: 'authenticated_${user.id}',
    );
    return user;
  }

  @override
  Future<User> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final user = await _remote.signUp(
      email: email,
      password: password,
      displayName: displayName,
    );
    await _local.saveCurrentUser(user);
    await _local.saveUser(user);
    await _secureStorage.write(
      key: 'auth_token',
      value: 'authenticated_${user.id}',
    );
    return user;
  }

  @override
  Future<User> signInWithGoogle() async {
    final user = await _remote.signInWithGoogle();
    await _local.saveCurrentUser(user);
    await _local.saveUser(user);
    await _secureStorage.write(
      key: 'auth_token',
      value: 'authenticated_${user.id}',
    );
    return user;
  }

  @override
  Future<void> signOut() async {
    await _remote.signOut();
    await _local.clearCurrentUser();
    await _secureStorage.delete(key: 'auth_token');
  }

  @override
  User? getCurrentUser() {
    return _remote.getCurrentUser();
  }

  @override
  Stream<User?> get authStateChanges => _remote.authStateChanges;

  @override
  bool get isAuthenticated => _remote.isAuthenticated;

  @override
  Future<void> registerFace({
    required String userId,
    required List<double> faceEmbedding,
    required String faceImageUrl,
  }) async {
    // Save to local (encrypted)
    await _local.saveFaceEmbedding(userId: userId, embedding: faceEmbedding);

    // Update local user
    final currentUser = await _local.getCurrentUser();
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        faceImageUrl: faceImageUrl,
        faceVerified: true,
        updatedAt: DateTime.now(),
      );
      await _local.saveCurrentUser(updatedUser);
      await _local.saveUser(updatedUser);
    }
  }

  @override
  Future<bool> verifyFace({
    required String userId,
    required List<double> liveEmbedding,
    required double threshold,
  }) async {
    final stored = await _local.getFaceEmbedding(userId);
    if (stored == null) return false;

    // Cosine similarity
    final similarity = _cosineSimilarity(liveEmbedding, stored);
    return similarity >= threshold;
  }

  @override
  Future<List<double>?> getFaceEmbedding(String userId) async {
    return await _local.getFaceEmbedding(userId);
  }

  double _cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) return 0.0;
    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;
    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    if (normA == 0.0 || normB == 0.0) return 0.0;
    return dotProduct / (normA * normB);
  }
}
