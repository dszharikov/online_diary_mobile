part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Событие для загрузки списка школ при открытии страницы
class FetchSchoolsEvent extends LoginEvent {}

/// Пользователь выбрал школу из dropdown
class SchoolNameChangedEvent extends LoginEvent {
  final String schoolName; // или int, в зависимости от сервера

  const SchoolNameChangedEvent(this.schoolName);

  @override
  List<Object?> get props => [schoolName];
}

/// При вводе username/password
class UsernameChangedEvent extends LoginEvent {
  final String username;

  const UsernameChangedEvent(this.username);

  @override
  List<Object?> get props => [username];
}

class PasswordChangedEvent extends LoginEvent {
  final String password;

  const PasswordChangedEvent(this.password);

  @override
  List<Object?> get props => [password];
}

/// Клик на кнопку Login
class SubmitLoginEvent extends LoginEvent {}

/// Тик таймера блокировки (раз в секунду или как удобнее)
class LockTimerTickedEvent extends LoginEvent {
  final int remainingSeconds;

  const LockTimerTickedEvent(this.remainingSeconds);

  @override
  List<Object?> get props => [remainingSeconds];
}
