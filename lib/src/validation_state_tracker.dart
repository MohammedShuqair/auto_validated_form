import 'package:flutter/material.dart';

import 'extensions/field_model_map_extension.dart';
import 'models/field_model.dart';
import 'types.dart';

/// Tracks the validation state of all form fields in an [AutoValidatedForm].
class ValidationStateTracker {
  /// Stores [ValidationListener] for each field registered with [ValidationStateTracker].
  final Map<String, ValidationListener> _listeners = {};

  late final Map<String, FieldModel> _defaultValues;

  /// Holds the reactive map of field IDs to their [FieldModel] states.
  late ValueNotifier<Map<String, FieldModel>> formValidationNotifier;

  /// Creates a tracker initialized with a map of [FieldModel] instances.
  ValidationStateTracker.byFields(Map<String, FieldModel> fields)
      : _defaultValues = Map.unmodifiable(fields) {
    formValidationNotifier = ValueNotifier(Map.of(fields));
    _initListeners(_defaultValues.keys);
  }

  /// Creates a tracker initialized with a list of [FieldModel] instances.
  ValidationStateTracker.byList(List<FieldModel> fields)
      : this.byFields({for (final field in fields) field.id: field});

  /// Deprecated legacy constructor. Use [ValidationStateTracker.byList] instead.
  @Deprecated('Use ValidationStateTracker.byList instead.')
  ValidationStateTracker.byValues(List<FieldModel> defaultValues)
      : this.byList(defaultValues);

  /// Creates a tracker with all specified field [ids] initialized to an unvalidated state.
  ValidationStateTracker.defaultFalse(List<String> ids) {
    _defaultValues = Map.unmodifiable({
      for (final id in ids) id: FieldModel(id: id),
    });
    formValidationNotifier = ValueNotifier(Map.of(_defaultValues));
    _initListeners(ids);
  }

  /// Returns the [ValidationListener] registered for [key], or `null` if not found.
  ValidationListener? validationListener(String key) => _listeners[key];

  void _initListeners(Iterable<String> keys) {
    for (final key in keys) {
      _listeners[key] = (errorMessage) {
        validate(key, errorMessage);
      };
    }
  }

  /// Updates the validation state for [key] with the given [errorMessage].
  void validate(String key, String errorMessage) {
    final currentMap = formValidationNotifier.value;
    final model = currentMap[key];
    if (model == null) return;

    if (!model.validated || errorMessage != model.errorText) {
      final updatedMap = Map<String, FieldModel>.of(currentMap);
      updatedMap[key] = model.copyWith(
        errorText: errorMessage,
        validated: true,
      );
      formValidationNotifier.value = updatedMap;
    }
  }

  /// Whether all registered fields have been validated and contain no errors.
  bool get isValid => formValidationNotifier.value.areAllValid;

  /// Disposes the underlying [formValidationNotifier].
  void dispose() {
    formValidationNotifier.dispose();
  }

  /// Resets all fields to their default unvalidated values.
  void reset() {
    formValidationNotifier.value = Map.of(_defaultValues);
  }
}
