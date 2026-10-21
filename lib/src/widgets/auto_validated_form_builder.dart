import 'package:flutter/material.dart';

import '../extensions/field_model_map_extension.dart';
import '../models/field_model.dart';
import 'auto_validated_form_scope.dart';

/// A widget that rebuilds whenever the validation state of the form changes.
class AutoValidatedFormBuilder extends StatelessWidget {
  /// Creates an [AutoValidatedFormBuilder].
  const AutoValidatedFormBuilder({
    super.key,
    this.value,
    required this.builder,
    this.child,
  });

  /// Optional explicit notifier to listen to.
  ///
  /// If omitted, the notifier is resolved from the nearest [AutoValidatedFormScope].
  final ValueNotifier<Map<String, FieldModel>>? value;

  /// An optional child widget passed to [builder] to optimize subtree rebuilding.
  final Widget? child;

  /// The builder callback invoked when the form validation state updates.
  final Widget Function(
    BuildContext context,
    Map<String, FieldModel> fields,
    bool isValid,
    Widget? child,
  ) builder;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Map<String, FieldModel>>? formValidationNotifier =
        value ??
            AutoValidatedFormScope.of(
              context,
              listen: false,
            )?.validationStateTracker.formValidationNotifier;

    if (formValidationNotifier == null) {
      throw StateError(
        'AutoValidatedFormBuilder requires either an explicit "value" or '
        'an AutoValidatedFormScope in the widget tree.',
      );
    }

    return ValueListenableBuilder<Map<String, FieldModel>>(
      valueListenable: formValidationNotifier,
      builder: (context, fields, child) =>
          builder(context, fields, fields.areAllValid, child),
      child: child,
    );
  }
}
