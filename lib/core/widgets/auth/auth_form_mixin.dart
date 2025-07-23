import 'package:flutter/material.dart';

mixin AuthFormMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void handleFormSubmission(VoidCallback onValidForm) {
    if (validateForm()) {
      onValidForm();
    }
  }
}
