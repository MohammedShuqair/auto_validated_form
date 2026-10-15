import 'package:auto_validated_form/auto_validated_form.dart';
import 'package:flutter/material.dart';

class AutoValidatedFormBuilder extends StatelessWidget {
  const AutoValidatedFormBuilder({
    super.key,
    this.value,
    required this.builder,
    this.child,
  });
  final ValueNotifier<Map<String, String>>? value;
  final Widget? child;
  final Widget Function(
    BuildContext,
    Map<String, String> validationState,
    bool isValid,
    Widget? child,
  )
  builder;
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Map<String, String>>? formValidationNotifier =
        AutoValidatedFormScope.of(
          context,
          listen: false,
        )?.validationStateTracker.formValidationNotifier ??
        value;
    if (formValidationNotifier == null) {
      throw Exception('');
    }
    return ValueListenableBuilder<Map<String, String>>(
      valueListenable: formValidationNotifier,
      builder: (context, validationState, child) => builder(
        context,
        validationState,
        !validationState.values.any((e) => e.isNotEmpty),
        child,
      ),
      child: child,
    );
  }
}
