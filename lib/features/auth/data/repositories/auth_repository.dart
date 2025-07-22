import 'package:movieapp/core/error/failures.dart';
import 'package:movieapp/features/auth/data/models/login_request_model.dart';
import 'package:movieapp/features/auth/data/models/register_request_model.dart';
import 'package:movieapp/features/auth/data/models/user_model.dart';

import '../../../../core/error/either.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> login(LoginRequestModel loginRequest);
  Future<Either<Failure, UserModel>> register(RegisterRequestModel registerRequest);
  Future<Either<Failure, UserModel>> getProfile();
  Future<Either<Failure, void>> logout();
}
