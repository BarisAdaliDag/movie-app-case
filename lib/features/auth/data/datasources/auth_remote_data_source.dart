import 'package:movieapp/features/auth/data/models/login_request_model.dart';
import 'package:movieapp/features/auth/data/models/register_request_model.dart';
import 'package:movieapp/features/auth/data/models/user_model.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/network_client.dart';
import '../../../../core/utils/secure_storage.dart';
import 'auth_datasource.dart';

class AuthRemoteDatasource implements AuthDatasource {
  final NetworkClient networkClient;

  AuthRemoteDatasource({required this.networkClient});

  @override
  Future<UserModel> login(LoginRequestModel loginRequest) async {
    final response = await networkClient.post(endpoint: ApiConstants.login, body: loginRequest.toJson());

    final userModel = UserModel.fromJson(response['data']);
    final token = response['data']['token'];

    await SecureStorage.storeToken(token);
    return userModel.copyWith(token: token);
  }

  @override
  Future<UserModel> register(RegisterRequestModel registerRequest) async {
    final response = await networkClient.post(endpoint: ApiConstants.register, body: registerRequest.toJson());

    final userModel = UserModel.fromJson(response['data']);
    final token = response['data']['token'];

    await SecureStorage.storeToken(token);
    return userModel.copyWith(token: token);
  }

  @override
  Future<UserModel> getProfile() async {
    final token = await SecureStorage.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await networkClient.get(
      endpoint: ApiConstants.profile,
      headers: {ApiConstants.authorization: '${ApiConstants.bearer} $token'},
    );

    return UserModel.fromJson(response['data']);
  }

  @override
  Future<void> logout() async {
    await SecureStorage.clearAll();
  }
}
