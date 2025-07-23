import 'package:movieapp/features/data/models/auth/login_request_model.dart';
import 'package:movieapp/features/data/models/auth/register_request_model.dart';
import 'package:movieapp/features/data/models/auth/user_model.dart';

abstract class AuthDatasource {
  Future<UserModel> login(LoginRequestModel loginRequest);
  Future<UserModel> register(RegisterRequestModel registerRequest);
  Future<UserModel> getProfile();
  Future<void> logout();
}
