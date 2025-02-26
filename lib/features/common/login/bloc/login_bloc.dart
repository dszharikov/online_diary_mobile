import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_diary_mobile/core/errors/failure.dart';
import 'package:online_diary_mobile/features/common/auth/repositories/auth_repository.dart';
import 'package:online_diary_mobile/features/common/login/data/models/school.dart';
import 'package:online_diary_mobile/features/common/login/repository/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
  final AuthRepository authRepository;

  Timer? _lockTimer;

  LoginBloc({required this.loginRepository, required this.authRepository})
    : super(const LoginState()) {
    on<FetchSchoolsEvent>(_onFetchSchools);
    on<SchoolSelectedEvent>(_onSchoolSelected);
    on<UsernameChangedEvent>(_onUsernameChanged);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<SubmitLoginEvent>(_onSubmitLogin);
    on<LockTimerTickedEvent>(_onLockTimerTicked);
  }

  Future<void> _onFetchSchools(
    FetchSchoolsEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final fetchedSchools = await loginRepository.fetchSchools();
      fetchedSchools.fold(
        (failure) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'Failed to load schools',
            ),
          );
        },
        (schools) {
          emit(state.copyWith(isLoading: false, schools: schools));
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load schools',
        ),
      );
    }
  }

  void _onSchoolSelected(SchoolSelectedEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(selectedSchoolId: event.schoolId));
  }

  void _onUsernameChanged(
    UsernameChangedEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(username: event.username));
  }

  void _onPasswordChanged(
    PasswordChangedEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onSubmitLogin(
    SubmitLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    // 1) Проверить, заблокирован ли пользователь
    if (state.isLocked) {
      // Ничего не делаем, пользователь должен ждать
      return;
    }

    // 2) Проверить валидацию полей (школа, username, password)
    // if (state.selectedSchoolId == null || state.selectedSchoolId!.isEmpty) {
    //   emit(state.copyWith(errorMessage: 'School not selected'));
    //   return;
    // }
    // TODO: Uncomment the above code and remove the below code
    var schoolId = '01JFQ1RPZRD46S3S4XY5KE7EM2';
    if (state.username.isEmpty) {
      emit(state.copyWith(errorMessage: 'Username is empty'));
      return;
    }
    if (state.password.isEmpty) {
      emit(state.copyWith(errorMessage: 'Password is empty'));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));
    // 3) Отправляем запрос на логин
    final result = await authRepository.logIn(
      // schoolId: state.selectedSchoolId!,
      schoolId: schoolId,
      username: state.username,
      password: state.password,
    );

    result.fold(
      (failure) {
        if (failure is ServerDeclineFailure) {
          // Логин неуспешен
          final newAttempts = state.failedAttemptsCount + 1;

          // Если превысило 5 попыток, блокируем на 60 секунд
          if (newAttempts >= 5) {
            _startLockTimer(emit);
            emit(
              state.copyWith(
                isLoading: false,
                failedAttemptsCount: newAttempts,
                errorMessage: 'Too many attempts, locked for 1 minute',
              ),
            );
          } else {
            emit(
              state.copyWith(
                isLoading: false,
                failedAttemptsCount: newAttempts,
                errorMessage: 'Invalid username or password',
              ),
            );
          }
        } else {
          log('Unknown failure: $failure');
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'Something went wrong, try again later',
            ),
          );
        }
      },
      (result) {
        // Сбросить счётчик неудачных попыток
        emit(
          state.copyWith(
            isLoading: false,
            failedAttemptsCount: 0,
            errorMessage: null,
          ),
        );
      },
    );
  }

  /// Запускаем таймер на 60 секунд
  void _startLockTimer(Emitter<LoginState> emit) {
    // Обозначаем, что пользователь заблокирован
    emit(state.copyWith(isLocked: true, lockSecondsRemaining: 60));

    _lockTimer?.cancel();
    _lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = state.lockSecondsRemaining;
      final updated = current - 1;
      if (updated <= 0) {
        timer.cancel();
        add(const LockTimerTickedEvent(0));
      } else {
        add(LockTimerTickedEvent(updated));
      }
    });
  }

  void _onLockTimerTicked(
    LockTimerTickedEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.remainingSeconds <= 0) {
      // Разблокируем
      emit(state.copyWith(isLocked: false, lockSecondsRemaining: 0));
    } else {
      emit(state.copyWith(lockSecondsRemaining: event.remainingSeconds));
    }
  }

  @override
  Future<void> close() {
    _lockTimer?.cancel();
    return super.close();
  }
}
