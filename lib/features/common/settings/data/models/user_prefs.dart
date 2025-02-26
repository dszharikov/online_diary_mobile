import 'dart:convert';

/// Минимальный класс настроек, только под тему.
class UserPrefs {
  final bool isDarkMode;

  UserPrefs({required this.isDarkMode});

  UserPrefs copyWith({bool? isDarkMode}) {
    return UserPrefs(isDarkMode: isDarkMode ?? this.isDarkMode);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'isDarkMode': isDarkMode};
  }

  factory UserPrefs.fromMap(Map<String, dynamic> map) {
    return UserPrefs(isDarkMode: map['isDarkMode'] as bool);
  }

  String toJson() => json.encode(toMap());

  factory UserPrefs.fromJson(String source) =>
      UserPrefs.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserPrefs(isDarkMode: $isDarkMode)';

  @override
  bool operator ==(covariant UserPrefs other) {
    if (identical(this, other)) return true;
    return other.isDarkMode == isDarkMode;
  }

  @override
  int get hashCode => isDarkMode.hashCode;
}
