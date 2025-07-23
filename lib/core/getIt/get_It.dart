import 'package:get_it/get_it.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/datasources/auth/auth_remote_data_source.dart';
import 'package:movieapp/features/presentation/login/cubit/login_cubit.dart';
import 'package:movieapp/features/presentation/photo_upload/cubit/photo_upload_cubit.dart';
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
}

void registerRepositories() {
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl(authDatasource: getIt<AuthDatasource>()));
}

void registerCubits() {
  getIt.registerFactory<AuthCubit>(() => AuthCubit(authRepository: getIt<AuthRepository>()));
  getIt.registerFactory<PhotoUploadCubit>(() => PhotoUploadCubit(authCubit: getIt<AuthCubit>()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit());
  getIt.registerFactory<RegisterCubit>(() => RegisterCubit());
}
