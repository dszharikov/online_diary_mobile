// settings_state.dart
part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final bool isDarkMode;

  const SettingsState({this.isDarkMode = false});

  SettingsState copyWith({bool? isDarkMode}) {
    return SettingsState(isDarkMode: isDarkMode ?? this.isDarkMode);
  }

  @override
  List<Object?> get props => [isDarkMode];
}
