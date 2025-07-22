import 'package:get_it/get_it.dart';
import 'package:movieapp/features/auth/data/datasources/auth_datasource.dart';
import 'package:movieapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:movieapp/features/auth/data/repositories/auth_repository.dart';
import 'package:movieapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:movieapp/features/auth/presentation/cubit/auth_cubit.dart';
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
}
