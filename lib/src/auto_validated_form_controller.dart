import 'widgets/auto_validated_field.dart';

class AutoValidatedFormController {
  AutoValidatedFieldState? state;

  void setState(AutoValidatedFieldState state) {
    this.state = state;
  }

  void validate() {
    state?.autoValidationNotifier.validate(forceValidate: true);
  }

  void dispose() {
    state = null;
  }
}
