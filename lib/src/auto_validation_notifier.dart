import 'package:flutter/material.dart';

import 'types.dart';

/// A [ChangeNotifier] that coordinates the validation timing and lifecycle for an individual field.
class AutoValidationNotifier extends ChangeNotifier {
  /// The [TextEditingController] being monitored.
  TextEditingController controller;

  /// The validator function to evaluate the input.
  String? Function(String?)? validator;

  /// The current error text, or an empty string if valid.
  String errorText = '';

  /// Optional listener notified when validation changes.
  final ValidationListener? validationListener;

  /// The [FocusNode] used to detect focus/blur events.
  final FocusNode focusNode;

  /// The previous text value before modification.
  String lastVal = '';

  /// Whether the field currently has an active validation error.
  bool get hasValidationError => errorText.isNotEmpty;

  /// Creates an [AutoValidationNotifier].
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
