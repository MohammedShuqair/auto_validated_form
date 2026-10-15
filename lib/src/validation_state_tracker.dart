import 'package:flutter/material.dart';

import 'types.dart';

class ValidationStateTracker {
  /// stores [ValidationListener] for each [FormField] registered with [ValidationStateTracker]
  /// Either by [ValidationStateTracker.byValues] or [ValidationStateTracker.defaultFalse]
  final Map<String, ValidationListener> _listeners = {};

  late final Map<String, String> _defaultValues;

  /// store validation state for each [AppField] registered with [ValidationStateTracker]
  /// Either by [ValidationStateTracker.byValues] or [ValidationStateTracker.length]
  late ValueNotifier<Map<String, String>> formValidationNotifier;

  ValidationStateTracker.byValues(Map<String, String> defaultValues)
    : _defaultValues = defaultValues {
    formValidationNotifier = ValueNotifier(defaultValues);
    _initListeners(defaultValues);
  }

  ValidationStateTracker.defaultFalse(List<String> keys) {
    _defaultValues = {for (String key in keys) key: ''};
    formValidationNotifier = ValueNotifier(_defaultValues);
    _initListeners(_defaultValues);
  }

  Function(String)? validationListener(String key) => _listeners[key];

  void _initListeners(Map<String, String> defaultValues) {
    for (String key in defaultValues.keys) {
      _listeners[key] = (errorMessage) {
        validate(key, errorMessage);
      };
    }
  }

  void validate(String key, String errorMessage) {
    final oldValues = formValidationNotifier.value;
    if (errorMessage != oldValues[key]) {
      final newValues = Map<String, String>.from(oldValues);
      newValues[key] = errorMessage;
      formValidationNotifier.value = newValues;
    }
  }

  bool get isValid =>
      !formValidationNotifier.value.values.any((e) => e.isNotEmpty);

  void dispose() {
    formValidationNotifier.dispose();
  }

  void reset() {
    formValidationNotifier.value = _defaultValues;
  }
}
