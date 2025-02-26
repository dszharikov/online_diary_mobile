import 'key_value_storage_base.dart';

/// A service class for providing methods to store and retrieve key-value data
/// from common or secure storage.
class KeyValueStorageService {
  /// The name of auth token key
  static const _authTokenKey = 'authToken';

  /// The name of auth token key
  static const _refreshTokenKey = 'refreshToken';

  /// The name of user prefs key
  static const _userPrefsKey = 'userPrefs';

  /// Instance of key-value storage base class
  final _keyValueStorage = KeyValueStorageBase();

  /// Returns last authentication token
  Future<String?> getAccessToken() async {
    return await _keyValueStorage.getEncrypted(_authTokenKey);
  }

  /// Sets the authentication token to this value. Even though this method is
  /// asynchronous, we don't care about it's completion which is why we don't
  /// use `await` and let it execute in the background.
  void setAccessToken(String token) {
    _keyValueStorage.setEncrypted(_authTokenKey, token);
  }

  /// Returns refresh token
  Future<String?> getRefreshToken() async {
    return await _keyValueStorage.getEncrypted(_refreshTokenKey);
  }

  /// Sets the refresh token to this value. Even though this method is
  /// asynchronous, we don't care about it's completion which is why we don't
  /// use `await` and let it execute in the background.
  void setRefreshToken(String token) {
    _keyValueStorage.setEncrypted(_refreshTokenKey, token);
  }

  String? getUserPrefs() {
    var result = _keyValueStorage.getCommon<String>(_userPrefsKey);
    return result;
  }

  void setUserPrefs(String json) {
    _keyValueStorage.setCommon<String>(_userPrefsKey, json);
  }

  /// Resets the authentication. Even though these methods are asynchronous, we
  /// don't care about their completion which is why we don't use `await` and
  /// let them execute in the background.
  void resetKeys() {
    _keyValueStorage
      ..clearCommon()
      ..clearEncrypted();
  }

  void resetTokens() {
    _keyValueStorage.clearEncrypted();
  }
}
