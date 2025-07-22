import 'package:dio/dio.dart';
import 'package:movieapp/core/error/failures.dart';
import 'package:movieapp/features/auth/data/datasources/auth_datasource.dart';
import 'package:movieapp/features/auth/data/models/login_request_model.dart';
import 'package:movieapp/features/auth/data/models/register_request_model.dart';
import 'package:movieapp/features/auth/data/models/user_model.dart';
import 'package:movieapp/features/auth/domain/repositories/auth_repository.dart';
import '../../../../core/error/either.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImpl({required this.authDatasource});

  @override
  Future<Either<Failure, UserModel>> login(LoginRequestModel loginRequest) async {
    try {
      final user = await authDatasource.login(loginRequest);
      return Right(user);
    } on DioException catch (e) {
      return Left(AuthFailure(errorMessage: e.response?.data['message'] ?? 'Login failed'));
    } catch (e) {
      return Left(AuthFailure(errorMessage: 'Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> register(RegisterRequestModel registerRequest) async {
    try {
      final user = await authDatasource.register(registerRequest);
      return Right(user);
    } on DioException catch (e) {
      return Left(AuthFailure(errorMessage: e.response?.data['message'] ?? 'Registration failed'));
    } catch (e) {
      return Left(AuthFailure(errorMessage: 'Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getProfile() async {
    try {
      final user = await authDatasource.getProfile();
      return Right(user);
    } on DioException catch (e) {
      return Left(AuthFailure(errorMessage: e.response?.data['message'] ?? 'Failed to get profile'));
    } catch (e) {
      return Left(AuthFailure(errorMessage: 'Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authDatasource.logout();
      return Right(null);
    } catch (e) {
      return Left(AuthFailure(errorMessage: 'Logout failed'));
    }
  }
}
