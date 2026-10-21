import 'package:auto_validated_form/auto_validated_form.dart';
import 'package:flutter/widgets.dart';

class AutoValidatedFormScope extends InheritedWidget {
  const AutoValidatedFormScope({
    super.key,
    required super.child,
    required this.validationStateTracker,
  });

  final ValidationStateTracker validationStateTracker;

  static AutoValidatedFormScope? of(
    BuildContext context, {
    bool listen = true,
  }) {
    late AutoValidatedFormScope? provider;
    if (listen) {
      provider = context
          .dependOnInheritedWidgetOfExactType<AutoValidatedFormScope>();
    } else {
      provider = context
          .getInheritedWidgetOfExactType<AutoValidatedFormScope>();
    }
    return provider;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      validationStateTracker !=
      (oldWidget as AutoValidatedFormScope).validationStateTracker;
}
