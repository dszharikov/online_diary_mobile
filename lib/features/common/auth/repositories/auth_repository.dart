// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:online_diary_mobile/core/errors/failure.dart';
import 'package:online_diary_mobile/features/common/auth/data/models/authorization_result.dart';
import 'package:online_diary_mobile/features/common/auth/data/sources/auth_local_data_source.dart';
import 'package:online_diary_mobile/features/common/auth/data/sources/auth_remote_data_source.dart';

class AuthStatus {
  String? role;
  bool isAuthenticated;

  AuthStatus.unknown() : isAuthenticated = false;
  // TODO: remake it
  AuthStatus.authenticated({required this.role}) : isAuthenticated = true;
  AuthStatus.unauthenticated() : isAuthenticated = false;
}

class AuthRepository {
  final controller = StreamController<AuthStatus>();
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  Stream<AuthStatus> get status async* {
    yield AuthStatus.unknown();

    var authResult = await checkTokenValidity();

    authResult.fold(
      (failure) => controller.add(AuthStatus.unauthenticated()),
      (result) => controller.add(AuthStatus.authenticated(role: result.role)),
    );
    yield* controller.stream;
  }

  Future<Either<Failure, AuthorizationResult>> logIn({
    required String schoolId,
    required String username,
    required String password,
  }) async {
    try {
      var result = await remoteDataSource.logIn(
        schoolId: schoolId,
        username: username,
        password: password,
      );
      await localDataSource.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      controller.add(AuthStatus.authenticated(role: result.role));
      return Right(result);
    } catch (e) {
      controller.add(AuthStatus.unauthenticated());
      return Left(ServerDeclineFailure());
    }
  }

  void logOut() {
    localDataSource.deleteTokens();
    controller.add(AuthStatus.unauthenticated());
  }

  Future<Either<Failure, AuthorizationResult>> checkTokenValidity() async {
    final refreshToken = await localDataSource.getRefreshToken();
    if (refreshToken == null) {
      return Left(CacheFailure());
    } else {
      try {
        final result = await remoteDataSource.refreshAuthorization(
          refreshToken: refreshToken,
        );

        localDataSource.saveTokens(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
        );
        controller.add(AuthStatus.authenticated(role: result.role));
        return Right(result);
      } catch (e) {
        controller.add(AuthStatus.unauthenticated());
        return Left(ServerDeclineFailure());
      }
    }
  }

  void dispose() => controller.close();
}
