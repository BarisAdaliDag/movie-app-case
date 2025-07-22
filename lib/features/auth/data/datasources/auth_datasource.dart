import 'package:movieapp/features/auth/data/models/login_request_model.dart';
import 'package:movieapp/features/auth/data/models/register_request_model.dart';
import 'package:movieapp/features/auth/data/models/user_model.dart';

abstract class AuthDatasource {
  Future<UserModel> login(LoginRequestModel loginRequest);
  Future<UserModel> register(RegisterRequestModel registerRequest);
  Future<UserModel> getProfile();
  Future<void> logout();
}
