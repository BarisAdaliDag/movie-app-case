import 'dart:convert';
import 'dart:io';

import 'package:movieapp/core/error/error_handler.dart';
import 'package:movieapp/core/error/failures.dart';
import 'package:movieapp/core/services/photo_upload_service.dart';
import 'package:movieapp/features/data/datasources/auth/auth_datasource.dart';
import 'package:movieapp/features/data/models/auth/login_request_model.dart';
import 'package:movieapp/features/data/models/auth/register_request_model.dart';
import 'package:movieapp/features/data/models/auth/user_model.dart';
import 'package:movieapp/features/data/repositories/auth/auth_repository.dart';
import '../../../../core/error/either.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImpl({required this.authDatasource});

  @override
  Future<Either<Failure, UserModel>> login(LoginRequestModel loginRequest) async {
    try {
      final user = await authDatasource.login(loginRequest);
      return Right(user);
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }

  @override
  Future<Either<Failure, UserModel>> register(RegisterRequestModel registerRequest) async {
    try {
      final user = await authDatasource.register(registerRequest);
      return Right(user);
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getProfile() async {
    try {
      final user = await authDatasource.getProfile();
      return Right(user);
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authDatasource.logout();
      return Right(null);
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }

  @override
  Future<Either<Failure, UserModel>> uploadProfilePhoto(File imageFile) async {
    try {
      final response = await PhotoUploadService.uploadPhoto(imageFile);

      if (response['success'] == true) {
        final responseData = jsonDecode(response['data']);
        final userData = responseData['data'];
        final updatedUser = UserModel.fromJson(userData);
        return Right(updatedUser);
      } else {
        return Left(AuthFailure.serverError());
      }
    } catch (error) {
      return Left(ErrorHandler.handleError(error));
    }
  }
}
