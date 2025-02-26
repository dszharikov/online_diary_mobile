part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsStarted extends SettingsEvent {}

/// Переключить тему (dark <-> light)
class SettingsThemeToggled extends SettingsEvent {}

/// Установить конкретное значение темы (dark/light)
class SettingsThemeSet extends SettingsEvent {
  final bool isDark;
  const SettingsThemeSet(this.isDark);

  @override
  List<Object?> get props => [isDark];
}
