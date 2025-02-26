part of 'login_bloc.dart';

class LoginState extends Equatable {
  final bool isLoading; // Показывает, идёт ли загрузка
  final List<School> schools; // Список школ
  final String? selectedSchoolId; // ID выбранной школы
  final String username;
  final String password;
  final String? errorMessage; // Для отображения ошибок
  final bool isLocked; // Заблокирован ли вход
  final int
  lockSecondsRemaining; // Сколько секунд осталось до разблокировки (0, если не заблокирован)
  final int
  failedAttemptsCount; // Сколько раз подряд неверно ввели логин/пароль

  const LoginState({
    this.isLoading = false,
    this.schools = const [],
    this.selectedSchoolId,
    this.username = '',
    this.password = '',
    this.errorMessage,
    this.isLocked = false,
    this.lockSecondsRemaining = 0,
    this.failedAttemptsCount = 0,
  });

  LoginState copyWith({
    bool? isLoading,
    List<School>? schools,
    String? selectedSchoolId,
    String? username,
    String? password,
    String? errorMessage,
    bool? isLocked,
    int? lockSecondsRemaining,
    int? failedAttemptsCount,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      schools: schools ?? this.schools,
      selectedSchoolId: selectedSchoolId ?? this.selectedSchoolId,
      username: username ?? this.username,
      password: password ?? this.password,
      errorMessage: errorMessage,
      isLocked: isLocked ?? this.isLocked,
      lockSecondsRemaining: lockSecondsRemaining ?? this.lockSecondsRemaining,
      failedAttemptsCount: failedAttemptsCount ?? this.failedAttemptsCount,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    schools,
    selectedSchoolId,
    username,
    password,
    errorMessage,
    isLocked,
    lockSecondsRemaining,
    failedAttemptsCount,
  ];
}
