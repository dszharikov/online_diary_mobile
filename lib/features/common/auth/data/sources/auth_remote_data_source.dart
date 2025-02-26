import 'package:dio/dio.dart';
import 'package:online_diary_mobile/core/networking/networking.dart';
import 'package:online_diary_mobile/features/common/auth/data/models/authorization_result.dart';
import 'package:online_diary_mobile/helpers/typedefs.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<AuthorizationResult> logIn({
    required String username,
    required String password,
    required String schoolId,
  }) async {
    final data = {
      'grant_type': 'password',
      'username': username,
      'password': password,
      'school_id': schoolId,
    };

    final response = await dio.post<JSON>(
      ApiEndpoint.auth(AuthEndpoint.TOKEN),
      data: data,
      options: Options(
        headers: <String, Object?>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );
    // Check new token success
    final success = response.statusCode == 200;

    if (success) {
      return AuthorizationResult.fromMap(response.data!);
    } else {
      throw Exception('Unsuccessed refresh token');
    }
  }

  Future<AuthorizationResult> refreshAuthorization({
    required String refreshToken,
  }) async {
    final data = {'grant_type': 'refresh_token', 'refresh_token': refreshToken};

    final response = await dio.post<JSON>(
      ApiEndpoint.auth(AuthEndpoint.TOKEN),
      data: data,
      options: Options(
        headers: <String, Object?>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );
    // Check new token success
    final success = response.statusCode == 200;

    if (success) {
      return AuthorizationResult.fromMap(response.data!);
    } else {
      throw Exception('Unsuccessed refresh token');
    }
  }
}
