import 'package:online_diary_mobile/features/common/login/data/models/school.dart';

import '../../../../../core/networking/networking.dart';

class LoginRemoteDataSource {
  final ApiInterface api;

  LoginRemoteDataSource({required this.api});

  Future<List<School>> getSchools() {
    return api.getCollectionData<School>(
      endpoint: ApiEndpoint.schools(SchoolsEndpoint.GET_ALL),
      converter: School.fromMap,
    );
  }
}
