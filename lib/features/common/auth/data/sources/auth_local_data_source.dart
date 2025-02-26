import 'package:online_diary_mobile/core/local/local.dart';

class AuthLocalDataSource {
  final KeyValueStorageService keyValueStorageService;

  AuthLocalDataSource({required this.keyValueStorageService});

  Future<String?> getAccessToken() async {
    return await keyValueStorageService.getAccessToken();
  }

  Future<String?> getRefreshToken() async {
    return await keyValueStorageService.getRefreshToken();
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    keyValueStorageService.setAccessToken(accessToken);
    keyValueStorageService.setRefreshToken(refreshToken);
  }

  Future<void> deleteTokens() async {
    keyValueStorageService.resetKeys();
  }
}
