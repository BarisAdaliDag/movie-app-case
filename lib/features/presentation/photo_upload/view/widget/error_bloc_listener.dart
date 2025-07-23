import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/utils/snackbar_helper.dart';

class ErrorBlocListener<B extends StateStreamable<S>, S> extends StatelessWidget {
  final Widget child;
  final String? Function(S state) errorExtractor;
  final VoidCallback? Function(S state)? clearErrorAction;
  final Function(BuildContext context, String error)? onError;

  const ErrorBlocListener({
    super.key,
    required this.child,
    required this.errorExtractor,
    this.clearErrorAction,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listener: (context, state) {
        final error = errorExtractor(state);
        if (error != null) {
          if (onError != null) {
            onError!(context, error);
          } else {
            SnackBarHelper.showError(context, error);
          }
          clearErrorAction?.call(state)?.call();
        }
      },
      child: child,
    );
  }
}
