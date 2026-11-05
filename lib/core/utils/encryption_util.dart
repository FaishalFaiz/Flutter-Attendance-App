/// Encryption utilities for sensitive data (face embeddings, tokens, etc.)
///
/// Uses AES-256 encryption via the `encrypt` package.
/// The encryption key is derived from AppConstants.encryptionKey.

import '../constants/app_constants.dart';
import 'package:encrypt/encrypt.dart' as encrypt_lib;

class EncryptionUtil {
  EncryptionUtil._();

  static final encrypt_lib.Key _key =
      encrypt_lib.Key.fromUtf8(AppConstants.encryptionKey);
  static final encrypt_lib.IV _iv =
      encrypt_lib.IV.fromUtf8(AppConstants.encryptionKey.substring(0, 16));

  /// Encrypt a string value (e.g., face embedding JSON)
  static String encrypt(String plainText) {
    final encrypter = encrypt_lib.Encrypter(
      encrypt_lib.AES(_key, mode: encrypt_lib.AESMode.cbc),
    );
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypt a base64-encoded encrypted string
  static String decrypt(String encryptedBase64) {
    final encrypter = encrypt_lib.Encrypter(
      encrypt_lib.AES(_key, mode: encrypt_lib.AESMode.cbc),
    );
    final decrypted = encrypter.decrypt64(encryptedBase64, iv: _iv);
    return decrypted;
  }

  /// Encrypt a list of doubles (face embedding)
  static String encryptEmbedding(List<double> embedding) {
    final json = embedding.join(',');
    return encrypt(json);
  }

  /// Decrypt and parse a list of doubles from encrypted string
  static List<double> decryptEmbedding(String encryptedBase64) {
    final json = decrypt(encryptedBase64);
    return json.split(',').map(double.tryParse).whereType<double>().toList();
  }
}