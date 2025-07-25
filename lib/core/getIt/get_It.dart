import 'package:get_it/get_it.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/datasources/auth/auth_remote_data_source.dart';
import 'package:movieapp/features/data/datasources/movie/movie_remote_data_source.dart';
import 'package:movieapp/features/data/repositories/movie/movie_repository.dart';
import 'package:movieapp/features/data/repositories/movie/movie_repository_impl.dart';
import 'package:movieapp/features/presentation/home/cubit/home_cubit.dart';
import 'package:movieapp/features/presentation/login/cubit/login_cubit.dart';
import 'package:movieapp/features/presentation/photo_upload/cubit/photo_upload_cubit.dart';
import 'package:movieapp/features/presentation/profile/cubit/profile_cubit.dart';
import 'package:movieapp/features/presentation/register/cubit/register_cubit.dart';
import '../../features/data/datasources/auth/auth_datasource.dart';
import '../../features/data/repositories/auth/auth_repository.dart';
import '../../features/data/repositories/auth/auth_repository_impl.dart';
import '../network/network_client.dart';

//Service locator for dependency injection
final getIt = GetIt.instance;

void setup() {
  registerNetworkClient();
  registerDatasources();
  registerRepositories();
  registerCubits();
}

void registerNetworkClient() {
  getIt.registerSingleton<NetworkClient>(NetworkClient());
}

void registerDatasources() {
  getIt.registerSingleton<AuthDatasource>(AuthRemoteDatasource(networkClient: getIt<NetworkClient>()));
  getIt.registerSingleton<MovieRemoteDatasource>(MovieRemoteDatasource(networkClient: getIt<NetworkClient>()));
}

void registerRepositories() {
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl(authDatasource: getIt<AuthDatasource>()));
  getIt.registerSingleton<MovieRepository>(MovieRepositoryImpl(remoteDatasource: getIt<MovieRemoteDatasource>()));
}

void registerCubits() {
  getIt.registerFactory<AuthCubit>(() => AuthCubit(authRepository: getIt<AuthRepository>()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(movieRepository: getIt<MovieRepository>()));
  getIt.registerFactory<PhotoUploadCubit>(() => PhotoUploadCubit(authCubit: getIt<AuthCubit>()));
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(movieRepository: getIt<MovieRepository>()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit());
  getIt.registerFactory<RegisterCubit>(() => RegisterCubit());
}
