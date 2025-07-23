import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AuthScaffold({super.key, required this.child, this.padding = const EdgeInsets.all(40)});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: SingleChildScrollView(padding: padding, child: child)));
  }
}
