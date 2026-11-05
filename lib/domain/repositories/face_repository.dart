/// Face repository contract - handles face recognition operations

import '../entities/face_embedding.dart';

abstract class FaceRepository {
  /// Register face embedding for a user
  Future<void> registerFace({
    required String userId,
    required List<double> embedding,
    required String faceImageUrl,
  });

  /// Get face embedding for a user
  Future<FaceEmbedding?> getFaceEmbedding(String userId);

  /// Verify a live embedding against stored embedding
  Future<bool> verifyFace({
    required String userId,
    required List<double> liveEmbedding,
    required double threshold,
  });

  /// Delete face data for a user
  Future<void> deleteFaceData(String userId);

  /// Check if user has face registered
  Future<bool> hasFaceRegistered(String userId);
}