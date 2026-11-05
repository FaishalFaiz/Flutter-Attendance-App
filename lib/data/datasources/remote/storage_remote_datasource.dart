/// Remote datasource for Firebase Storage operations

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../../core/errors/app_exception.dart';
import '../../constants/app_constants.dart';

class StorageRemoteDataSource {
  StorageRemoteDataSource._();
  static final StorageRemoteDataSource _instance = StorageRemoteDataSource._();
  factory StorageRemoteDataSource() => _instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload face image for a user in an organization
  Future<String> uploadFaceImage({
    required String orgId,
    required String userId,
    required List<int> imageBytes,
  }) async {
    try {
      final path = AppConstants.faceImagePath(orgId, userId);
      final ref = _storage.ref().child(path);

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'userId': userId,
          'orgId': orgId,
        },
      );

      await ref.putData(imageBytes, metadata);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw StorageException(message: 'Failed to upload face image: $e');
    }
  }

  /// Upload profile image for a user
  Future<String> uploadProfileImage({
    required String userId,
    required List<int> imageBytes,
  }) async {
    try {
      final path = AppConstants.profileImagePath(userId);
      final ref = _storage.ref().child(path);

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'userId': userId},
      );

      await ref.putData(imageBytes, metadata);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw StorageException(message: 'Failed to upload profile image: $e');
    }
  }

  /// Upload leave attachment
  Future<String> uploadLeaveAttachment({
    required String orgId,
    required String requestId,
    required String fileName,
    required List<int> fileBytes,
  }) async {
    try {
      final path = '${AppConstants.leaveAttachmentPath(orgId, requestId)}$fileName';
      final ref = _storage.ref().child(path);

      await ref.putData(fileBytes);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw StorageException(message: 'Failed to upload attachment: $e');
    }
  }

  /// Delete a file from storage
  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } catch (e) {
      throw StorageException(message: 'Failed to delete file: $e');
    }
  }

  /// Get download URL for a file
  Future<String> getDownloadUrl(String path) async {
    try {
      return await _storage.ref().child(path).getDownloadURL();
    } catch (e) {
      throw StorageException(message: 'Failed to get download URL: $e');
    }
  }
}