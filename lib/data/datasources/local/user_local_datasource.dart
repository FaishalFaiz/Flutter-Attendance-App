/// Local datasource for user data (Hive)

import 'package:hive/hive.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/encryption_util.dart';
import '../../../../domain/entities/face_embedding.dart';
import '../../../../domain/entities/user.dart';
import '../../datasources/local/hive_service.dart';

class UserLocalDataSource {
  UserLocalDataSource._();
  static final UserLocalDataSource _instance = UserLocalDataSource._();
  factory UserLocalDataSource() => _instance;

  Future<void> saveUser(User user) async {
    try {
      final box = HiveService().userBox;
      await box.put(user.id, user);
    } catch (e) {
      throw LocalStorageException(message: 'Failed to save user: $e');
    }
  }

  Future<User?> getUser(String userId) async {
    try {
      final box = HiveService().userBox;
      return box.get(userId);
    } catch (e) {
      throw LocalStorageException(message: 'Failed to get user: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final box = HiveService().authBox;
      final entries = box.values.toList();
      return entries.isNotEmpty ? entries.first : null;
    } catch (e) {
      throw LocalStorageException(message: 'Failed to get current user: $e');
    }
  }

  Future<void> saveCurrentUser(User user) async {
    try {
      final box = HiveService().authBox;
      await box.put('current_user', user);
    } catch (e) {
      throw LocalStorageException(message: 'Failed to save current user: $e');
    }
  }

  Future<void> clearCurrentUser() async {
    try {
      final box = HiveService().authBox;
      await box.clear();
    } catch (e) {
      throw LocalStorageException(message: 'Failed to clear user: $e');
    }
  }

  Future<void> saveFaceEmbedding({
    required String userId,
    required List<double> embedding,
  }) async {
    try {
      final encrypted = EncryptionUtil.encryptEmbedding(embedding);
      final box = HiveService().faceEmbeddingBox;
      await box.put(userId, FaceEmbedding(
        userId: userId,
        vector: embedding,
        encryptedVector: encrypted,
        sampleCount: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    } catch (e) {
      throw LocalStorageException(message: 'Failed to save face embedding: $e');
    }
  }

  Future<List<double>?> getFaceEmbedding(String userId) async {
    try {
      final box = HiveService().faceEmbeddingBox;
      final entity = box.get(userId);
      if (entity == null) return null;
      return EncryptionUtil.decryptEmbedding(entity.encryptedVector);
    } catch (e) {
      throw LocalStorageException(message: 'Failed to get face embedding: $e');
    }
  }

  Future<bool> hasFaceEmbedding(String userId) async {
    try {
      final box = HiveService().faceEmbeddingBox;
      return box.containsKey(userId);
    } catch (e) {
      return false;
    }
  }
}