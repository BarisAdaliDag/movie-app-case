import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/secure_storage.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/logout.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Register register;
  final GetProfile getProfile;
  final Logout logout;

  AuthBloc({required this.login, required this.register, required this.getProfile, required this.logout})
    : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<GetProfileEvent>(_onGetProfile);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      final token = await SecureStorage.getToken();
      if (token == null) {
        emit(AuthUnauthenticated());
        return;
      }

      final result = await getProfile();
      result.fold(
        (failure) {
          AppLogger.error('Auto-login failed: ${failure.message}');
          emit(AuthUnauthenticated());
        },
        (user) {
          AppLogger.info('Auto-login successful');
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (e) {
      AppLogger.error('Check auth status error', e);
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      final result = await login(event.email, event.password);
      result.fold(
        (failure) {
          AppLogger.error('Login failed1: ${failure.message}');
          emit(AuthError(message: failure.message));
        },
        (user) {
          AppLogger.info('Login successful for user: ${user.email}');
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (e) {
      AppLogger.error('Login error', e);
      emit(AuthError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      final result = await register(event.email, event.name, event.password);
      result.fold(
        (failure) {
          AppLogger.error('Registration failed: ${failure.message}');
          emit(AuthError(message: failure.message));
        },
        (user) {
          AppLogger.info('Registration successful for user: ${user.email}');
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (e) {
      AppLogger.error('Registration error', e);
      emit(AuthError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> _onGetProfile(GetProfileEvent event, Emitter<AuthState> emit) async {
    try {
      final result = await getProfile();
      result.fold(
        (failure) {
          AppLogger.error('Get profile failed: ${failure.message}');
          emit(AuthError(message: failure.message));
        },
        (user) {
          AppLogger.info('Profile fetched successfully');
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (e) {
      AppLogger.error('Get profile error', e);
      emit(AuthError(message: 'An unexpected error occurred'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      final result = await logout();
      result.fold(
        (failure) {
          AppLogger.error('Logout failed: ${failure.message}');
          emit(AuthError(message: failure.message));
        },
        (success) {
          AppLogger.info('Logout successful');
          emit(AuthUnauthenticated());
        },
      );
    } catch (e) {
      AppLogger.error('Logout error', e);
      emit(AuthError(message: 'An unexpected error occurred'));
    }
  }
}
