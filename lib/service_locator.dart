import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:online_diary_mobile/features/common/login/login.dart';
import 'core/local/local.dart';
import 'core/networking/networking.dart';
import 'features/common/auth/auth.dart';
import 'features/common/settings/settings.dart';

GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  // local storage
  await KeyValueStorageBase.init();
  sl.registerSingleton(KeyValueStorageService());

  // network
  final dio = Dio();
  sl.registerSingleton(dio);
  final ApiInterceptor apiInterceptor = ApiInterceptor(
    keyValueStorageService: sl(),
  );
  final RefreshTokenInterceptor refreshTokenInterceptor =
      RefreshTokenInterceptor(sl(), dioClient: sl());
  final interceptors = [apiInterceptor, refreshTokenInterceptor];
  sl.registerSingleton(DioService(dioClient: dio, interceptors: interceptors));
  sl.registerLazySingleton<ApiInterface>(() => ApiService(sl()));

  // data sources
  _localDataSources();
  _remoteDataSources();

  // repositories
  _repositories(refreshTokenInterceptor);

  // use cases
  _useCases();

  _bloc();
}

void _remoteDataSources() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSource(api: sl()),
  );
}

void _localDataSources() {
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(keyValueStorageService: sl()),
  );
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSource(keyValueStorageService: sl()),
  );
}

void _repositories(RefreshTokenInterceptor refreshTokenInterceptor) {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(localDataSource: sl(), remoteDataSource: sl()),
  );
  refreshTokenInterceptor.authController = sl<AuthRepository>().controller;
  // TODO: check if this is the right way to do it

  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepository(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );
}

void _useCases() {}

void _bloc() {
  sl.registerFactory<AuthBloc>(() => AuthBloc(authRepository: sl()));
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(loginRepository: sl(), authRepository: sl()),
  );
  sl.registerFactory<SettingsBloc>(
    () => SettingsBloc(settingsRepository: sl()),
  );
}
