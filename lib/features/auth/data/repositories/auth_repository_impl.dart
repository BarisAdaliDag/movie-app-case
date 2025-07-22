import 'package:dio/dio.dart';
import 'package:movieapp/core/error/error_handler.dart';
import 'package:movieapp/core/error/failures.dart';
import 'package:movieapp/features/auth/data/datasources/auth_datasource.dart';
import 'package:movieapp/features/auth/data/models/login_request_model.dart';
import 'package:movieapp/features/auth/data/models/register_request_model.dart';
import 'package:movieapp/features/auth/data/models/user_model.dart';
import 'package:movieapp/features/auth/data/repositories/auth_repository.dart';
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
}
