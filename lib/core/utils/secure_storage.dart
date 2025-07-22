import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
import '../error/exceptions.dart';

// class SecureStorage {
//   static const FlutterSecureStorage _storage = FlutterSecureStorage(
//     aOptions: AndroidOptions(encryptedSharedPreferences: true),
//     iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
//   );

//   static Future<void> storeToken(String token) async {
//     try {
//       await _storage.write(key: AppConstants.tokenKey, value: token);
//     } catch (e) {
//       throw CacheException('Failed to store token: ${e.toString()}');
//     }
//   }

//   static Future<String?> getToken() async {
//     try {
//       return await _storage.read(key: AppConstants.tokenKey);
//     } catch (e) {
//       throw CacheException('Failed to retrieve token: ${e.toString()}');
//     }
//   }

//   static Future<void> deleteToken() async {
//     try {
//       await _storage.delete(key: AppConstants.tokenKey);
//     } catch (e) {
//       throw CacheException('Failed to delete token: ${e.toString()}');
//     }
//   }

//   static Future<void> storeUserData(String userData) async {
//     try {
//       await _storage.write(key: AppConstants.userDataKey, value: userData);
//     } catch (e) {
//       throw CacheException('Failed to store user data: ${e.toString()}');
//     }
//   }

//   static Future<String?> getUserData() async {
//     try {
//       return await _storage.read(key: AppConstants.userDataKey);
//     } catch (e) {
//       throw CacheException('Failed to retrieve user data: ${e.toString()}');
//     }
//   }

//   static Future<void> deleteUserData() async {
//     try {
//       await _storage.delete(key: AppConstants.userDataKey);
//     } catch (e) {
//       throw CacheException('Failed to delete user data: ${e.toString()}');
//     }
//   }

//   static Future<void> clearAll() async {
//     try {
//       await _storage.deleteAll();
//     } catch (e) {
//       throw CacheException('Failed to clear storage: ${e.toString()}');
//     }
//   }
// }
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  static Future<void> storeToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
