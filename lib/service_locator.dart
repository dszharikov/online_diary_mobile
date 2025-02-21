import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'core/local/local.dart';
import 'core/networking/networking.dart';


GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  // local storage
  await KeyValueStorageBase.init();
  sl.registerSingleton(KeyValueStorageService());

  // network
  final dio = Dio();
  sl.registerSingleton(dio);
  final ApiInterceptor apiInterceptor =
      ApiInterceptor(keyValueStorageService: sl());
  final RefreshTokenInterceptor refreshTokenInterceptor =
      RefreshTokenInterceptor(sl(), dioClient: sl());
  final interceptors = [apiInterceptor, refreshTokenInterceptor];
  sl.registerSingleton(DioService(dioClient: dio, interceptors: interceptors));
  sl.registerLazySingleton<ApiInterface>(() => ApiService(sl()));

  // data sources
  _localDataSources();
  _remoteDataSources();

  // repositories
  _repositories();

  // use cases
  _useCases();

  _cubit();
}

void _remoteDataSources() {

}

void _localDataSources() {

}

void _repositories() {

}

void _useCases() {

}

void _cubit() {

}
