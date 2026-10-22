import 'widgets/auto_validated_field.dart';

/// An imperative controller that allows triggering validation manually on an [AutoValidatedField].
class AutoValidatedFormController {
  /// The attached [AutoValidatedFieldState], or `null` if not attached.
  AutoValidatedFieldState? state;

  /// Attaches the given [state] to this controller.
  void setState(AutoValidatedFieldState state) {
    this.state = state;
  }

  /// Triggers a forced validation check on the attached field.
  void validate() {
    state?.autoValidationNotifier.validate(forceValidate: true);
  }

  /// Disposes the controller and detaches its state reference.
  void dispose() {
    state = null;
  }
}
