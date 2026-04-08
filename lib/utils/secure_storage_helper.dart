import 'dart:developer' as dev;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Centralized helper for storing sensitive values in encrypted storage.
class SecureStorageHelper {
  static const String userPasswordKey = 'user_password_secure';

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  static Future<void> write(
      {required String key, required String value}) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e, st) {
      dev.log('SecureStorage write failed for key: $key',
          error: e, stackTrace: st);
    }
  }

  static Future<String> read({required String key}) async {
    try {
      return await _storage.read(key: key) ?? '';
    } catch (e, st) {
      dev.log('SecureStorage read failed for key: $key',
          error: e, stackTrace: st);
      return '';
    }
  }

  static Future<void> delete({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (e, st) {
      dev.log('SecureStorage delete failed for key: $key',
          error: e, stackTrace: st);
    }
  }

  static Future<void> saveUserPassword(String password) async {
    if (password.trim().isEmpty) {
      await delete(key: userPasswordKey);
      return;
    }

    await write(key: userPasswordKey, value: password);
  }

  static Future<String> getUserPassword() async {
    return read(key: userPasswordKey);
  }

  static Future<void> clearUserPassword() async {
    await delete(key: userPasswordKey);
  }
}
