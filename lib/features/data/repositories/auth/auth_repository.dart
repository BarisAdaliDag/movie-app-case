import 'dart:io';

import 'package:movieapp/core/error/failures.dart';
import 'package:movieapp/features/data/models/auth/login_request_model.dart';
import 'package:movieapp/features/data/models/auth/register_request_model.dart';
import 'package:movieapp/features/data/models/auth/user_model.dart';

import '../../../../core/error/either.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> login(LoginRequestModel loginRequest);
  Future<Either<Failure, UserModel>> register(RegisterRequestModel registerRequest);
  Future<Either<Failure, UserModel>> getProfile();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserModel>> uploadProfilePhoto(File imageFile);
}
