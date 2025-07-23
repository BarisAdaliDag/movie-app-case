import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/data/models/auth/login_request_model.dart';
import 'package:movieapp/features/data/models/auth/register_request_model.dart';
import 'package:movieapp/features/data/repositories/auth/auth_repository.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(const AuthState());

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(isLoading: true));

    final result = await authRepository.getProfile();

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false)),
      (user) => emit(state.copyWith(isLoading: false, user: user, isAuthenticated: true)),
    );
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await authRepository.login(LoginRequestModel(email: email, password: password));

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.errorMessage)),
      (user) => emit(state.copyWith(isLoading: false, user: user, isAuthenticated: true, errorMessage: null)),
    );
  }

  Future<void> register(String email, String name, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await authRepository.register(RegisterRequestModel(email: email, name: name, password: password));

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.errorMessage)),
      (user) => emit(state.copyWith(isLoading: false, user: user, isAuthenticated: true, errorMessage: null)),
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(isLoading: true));

    final result = await authRepository.logout();

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.errorMessage)),
      (_) => emit(const AuthState()),
    );
  }

  Future<void> uploadProfilePhoto(File imageFile) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await authRepository.uploadProfilePhoto(imageFile);

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.errorMessage)),
      (updatedUser) => emit(state.copyWith(isLoading: false, user: updatedUser, isAuthenticated: true)),
    );
  }

  // Hata mesajını temizle
  void clearError() {
    emit(state.withoutError());
  }
}
