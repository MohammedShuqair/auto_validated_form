import 'package:auto_validated_form/auto_validated_form.dart';
import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that provides the [ValidationStateTracker] to descendant widgets.
class AutoValidatedFormScope extends InheritedWidget {
  /// Creates an [AutoValidatedFormScope] with the given [validationStateTracker] and [child].
  const AutoValidatedFormScope({
    super.key,
    required super.child,
    required this.validationStateTracker,
  });

  /// The [ValidationStateTracker] managed by this scope.
  final ValidationStateTracker validationStateTracker;

  /// Retrieves the nearest [AutoValidatedFormScope] from the given [context].
  ///
  /// If [listen] is true, the calling widget will rebuild when the scope updates.
  static AutoValidatedFormScope? of(
    BuildContext context, {
    bool listen = true,
  }) {
    late AutoValidatedFormScope? provider;
    if (listen) {
      provider =
          context.dependOnInheritedWidgetOfExactType<AutoValidatedFormScope>();
    } else {
      provider =
          context.getInheritedWidgetOfExactType<AutoValidatedFormScope>();
    }
    return provider;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      validationStateTracker !=
      (oldWidget as AutoValidatedFormScope).validationStateTracker;
}
