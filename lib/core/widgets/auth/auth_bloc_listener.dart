import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/utils/snackbar_helper.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';

class AuthBlocListener extends StatelessWidget {
  final Widget child;
  final Function(BuildContext context, AuthState state)? onAuthenticated;
  final Function(BuildContext context, String errorMessage)? onError;

  const AuthBlocListener({super.key, required this.child, this.onAuthenticated, this.onError});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState.isAuthenticated && authState.user != null) {
          onAuthenticated?.call(context, authState);
        }

        if (authState.errorMessage != null) {
          if (onError != null) {
            onError!(context, authState.errorMessage!);
          } else {
            SnackBarHelper.showError(context, authState.errorMessage!);
          }
          context.read<AuthCubit>().clearError();
        }
      },
      child: child,
    );
  }
}
