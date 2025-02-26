import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../repository/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsBloc({required this.settingsRepository})
    : super(const SettingsState()) {
    on<SettingsStarted>(_onSettingsStarted);
    on<SettingsThemeToggled>(_onSettingsThemeToggled);
    on<SettingsThemeSet>(_onSettingsThemeSet);
  }

  Future<void> _onSettingsStarted(
    SettingsStarted event,
    Emitter<SettingsState> emit,
  ) async {
    // 1. Загружаем ранее сохранённые настройки (isDarkMode)
    final prefs = await settingsRepository.getUserSettings();
    final bool isDark = prefs?.isDarkMode ?? false;

    emit(state.copyWith(isDarkMode: isDark));
  }

  Future<void> _onSettingsThemeToggled(
    SettingsThemeToggled event,
    Emitter<SettingsState> emit,
  ) async {
    final newValue = !state.isDarkMode;
    // Сохраняем в репозиторий
    await settingsRepository.setDarkThemeEnabled(newValue);
    emit(state.copyWith(isDarkMode: newValue));
  }

  Future<void> _onSettingsThemeSet(
    SettingsThemeSet event,
    Emitter<SettingsState> emit,
  ) async {
    await settingsRepository.setDarkThemeEnabled(event.isDark);
    emit(state.copyWith(isDarkMode: event.isDark));
  }
}
