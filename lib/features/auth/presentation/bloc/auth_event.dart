import '../../domain/entities/user.dart';

abstract class AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String name;
  final String password;

  RegisterEvent({
    required this.email,
    required this.name,
    required this.password,
  });
}

class GetProfileEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}