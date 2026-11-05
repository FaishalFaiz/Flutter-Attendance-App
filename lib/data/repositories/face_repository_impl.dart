/// Face repository implementation

import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/encryption_util.dart';
import '../../../../domain/entities/face_embedding.dart';
import '../../../../domain/repositories/face_repository.dart';
import '../../datasources/local/user_local_datasource.dart';
import '../../datasources/remote/firestore_remote_datasource.dart';

class FaceRepositoryImpl implements FaceRepository {
  FaceRepositoryImpl._();
  static final FaceRepositoryImpl _instance = FaceRepositoryImpl._();
  factory FaceRepositoryImpl() => _instance;

  final _remote = FirestoreRemoteDataSource();
  final _local = UserLocalDataSource();

  @override
  Future<void> registerFace({
    required String userId,
    required List<double> embedding,
    required String faceImageBase64,
  }) async {
    // Save locally first (encrypted embedding)
    await _local.saveFaceEmbedding(userId: userId, embedding: embedding);

    // Save to remote (Firestore) - faceImageBase64 stored directly
    final encrypted = EncryptionUtil.encryptEmbedding(embedding);
    await _remote.saveFaceEmbeddingToFirestore(
      userId: userId,
      encryptedVector: encrypted,
      faceImageBase64: faceImageBase64,
    );
  }

  @override
  Future<List<double>?> getFaceEmbeddingVector(String userId) async {
    return await _local.getFaceEmbedding(userId);
  }

  @override
  Future<bool> verifyFace({
    required String userId,
    required List<double> liveEmbedding,
    required double threshold,
  }) async {
    final stored = await _local.getFaceEmbedding(userId);
    if (stored == null || stored.isEmpty) return false;

    final similarity = _cosineSimilarity(liveEmbedding, stored);
    return similarity >= threshold;
  }

  @override
  Future<void> deleteFaceData(String userId) async {
    await _local.saveFaceEmbedding(userId: userId, embedding: const []);
    try {
      await _remote.updateUserProfile(
        userId: userId,
        data: {
          'faceVerified': false,
          'faceImageBase64': null,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      throw StorageException(message: 'Failed to delete face data remotely: $e');
    }
  }

  @override
  Future<bool> hasFaceRegistered(String userId) async {
    return await _local.hasFaceEmbedding(userId);
  }

  /// Kompress image untuk mengurangi ukuran sebelum disimpan ke Firestore
  static Future<String> compressAndEncodeImage(Uint8List imageBytes,
      {int maxWidth = 600, int maxHeight = 600, int quality = 75}) async {
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      throw AppException(message: 'Gagal memproses image.');
    }

    // Resize if too large
    if (image.width > maxWidth || image.height > maxHeight) {
      final resized = img.copyResize(
        image,
        width: maxWidth,
        height: maxHeight,
        maintainAspect: true,
      );
      final compressed = img.encodeJpg(resized, quality: quality);
      return base64Encode(compressed);
    }

    final compressed = img.encodeJpg(image, quality: quality);
    return base64Encode(compressed);
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

/// Placeholder for StorageException (kept for compatibility)
class StorageException implements Exception {
  final String message;
  StorageException({required this.message});
  @override
  String toString() => message;
}
