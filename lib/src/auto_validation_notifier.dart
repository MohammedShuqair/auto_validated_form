import 'package:flutter/material.dart';

import 'types.dart';

class AutoValidationNotifier extends ChangeNotifier {
  TextEditingController controller;
  String? Function(String?)? validator;
  String errorText = '';
  final ValidationListener? validationListener;
  final FocusNode focusNode;
  String lastVal = '';

  bool get hasValidationError => errorText.isNotEmpty;

  AutoValidationNotifier({
    required this.focusNode,
    required this.controller,
    required this.validator,
    this.validationListener,
  }) {
    if (validator != null) {
      focusNode.addListener(_listenToFocus);
      controller.addListener(_listenToController);
    }
  }

  /// validate on unfocused and [errorText] is empty
  /// used when user focus on required filed then remove focus
  /// in this case [validate] is required
  void _listenToFocus() {
    if (!focusNode.hasFocus && errorText.isEmpty) {
      validate(forceValidate: true);
    }
  }

  /// [validate] when user interact with field
  /// when user start typing [lastVal] and [controller] are empty so no validation required
  /// when user clear text field
  /// [lastVal] will not be empty so [validate] will run
  /// and we forceValidate [validate] to pass [_newValidation]
  void _listenToController() {
    if (lastVal.isNotEmpty || controller.text.isNotEmpty) {
      validate(forceValidate: lastVal.isEmpty);
    }
    lastVal = controller.text;
  }

  /// if new validation or new state (valid,invalid)
  void validate({bool forceValidate = false}) {
    final String newErrorText = validator!.call(controller.text) ?? '';
    if (forceValidate || _newValidation(newErrorText)) {
      errorText = newErrorText;
      validationListener?.call(errorText);
      notifyListeners();
    }
  }

  bool _newValidation(String newErrorText) => newErrorText != errorText;

  /// do not dispose [controller] or [focusNode] here
  /// the responsibility of disposing them is on View/State Management where they initialized
  /// or else the app will dispose them twice which will cause
  /// A TextEditingController was used after being disposed
  @override
  void dispose() {
    if (validator != null) {
      focusNode.removeListener(_listenToFocus);
      controller.removeListener(_listenToController);
    }
    super.dispose();
  }
}
