import 'package:online_diary_mobile/core/local/local.dart';
import 'package:online_diary_mobile/features/common/settings/data/models/user_prefs.dart';

class SettingsLocalDataSource {
  final KeyValueStorageService keyValueStorageService;

  SettingsLocalDataSource({required this.keyValueStorageService});

  UserPrefs? getUserPrefs() {
    var storedJson = keyValueStorageService.getUserPrefs();
    if (storedJson != null) {
      return UserPrefs.fromJson(storedJson);
    }
    return null;
  }

  Future<void> saveUserPrefs(UserPrefs userPrefs) async {
    keyValueStorageService.setUserPrefs(userPrefs.toJson());
  }
}
