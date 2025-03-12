import 'package:dartz/dartz.dart';
import 'package:online_diary_mobile/core/errors/failure.dart';
import 'package:online_diary_mobile/features/common/login/data/sources/login_remote_data_source.dart';
import 'package:online_diary_mobile/features/common/login/data/models/school.dart';

class LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepository({required this.remoteDataSource});

  Future<Either<Failure, List<School>>> fetchSchools() async {
    try {
      // Получаем данные с сервера
      final schools = await remoteDataSource.getSchools();
      schools.sort((a, b) => a.name!.compareTo(b.name!));

      return Right(schools);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
