import 'package:online_diary_mobile/features/common/settings/data/models/user_prefs.dart';
import 'package:online_diary_mobile/features/common/settings/data/sources/settings_local_data_source.dart';

abstract class SettingsRepository {
  /// Получаем сохранённые настройки (возвращаем null, если ничего нет)
  Future<UserPrefs?> getUserSettings();

  /// Получить текущее значение тёмной темы
  Future<bool> getDarkThemeEnabled();

  /// Установить тёмную/светлую тему
  Future<void> setDarkThemeEnabled(bool enabled);
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<UserPrefs?> getUserSettings() async {
    return localDataSource.getUserPrefs();
  }

  @override
  Future<bool> getDarkThemeEnabled() async {
    final prefs = localDataSource.getUserPrefs();
    return prefs?.isDarkMode ?? false;
  }

  @override
  Future<void> setDarkThemeEnabled(bool enabled) async {
    // Получаем текущие prefs (или создаём новые)
    final currentPrefs =
        localDataSource.getUserPrefs() ?? UserPrefs(isDarkMode: false);
    final updated = currentPrefs.copyWith(isDarkMode: enabled);
    await localDataSource.saveUserPrefs(updated);
  }
}
