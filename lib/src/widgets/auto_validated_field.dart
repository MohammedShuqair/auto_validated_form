import 'package:auto_validated_form/auto_validated_form.dart';
import 'package:flutter/material.dart';

/// A generic wrapper widget that manages the auto-validation lifecycle for custom inputs.
class AutoValidatedField extends StatefulWidget {
  /// Creates an [AutoValidatedField].
  const AutoValidatedField({
    super.key,
    this.focusNode,
    required this.controller,
    this.validator,
    this.validationListener,
    required this.fieldBuilder,
    this.formController,
  });

  /// An optional [FocusNode] for this field. If omitted, an internal focus node is created.
  final FocusNode? focusNode;

  /// The [TextEditingController] holding the field value.
  final TextEditingController controller;

  /// The validator function returning an error string or `null` if valid.
  final String? Function(String?)? validator;

  /// Optional listener triggered when the validation error message changes.
  final ValidationListener? validationListener;

  /// Builder callback that provides the current [errorText] to build the input widget.
  final Widget Function(BuildContext context, String errorText) fieldBuilder;

  /// Optional [AutoValidatedFormController] to trigger validation imperatively.
  final AutoValidatedFormController? formController;

  @override
  State<AutoValidatedField> createState() => AutoValidatedFieldState();
}

class AutoValidatedFieldState extends State<AutoValidatedField> {
  late final AutoValidationNotifier autoValidationNotifier;
  late final FocusNode focusNode;

  void _initFocusNode() {
    if (widget.focusNode == null) {
      focusNode = FocusNode();
    } else {
      focusNode = widget.focusNode!;
    }
  }

  void _initFormController() {
    if (widget.formController != null) {
      widget.formController!.setState(this);
    }
  }

  @override
  void initState() {
    _initFormController();
    _initFocusNode();
    autoValidationNotifier = AutoValidationNotifier(
      focusNode: focusNode,
      controller: widget.controller,
      validator: widget.validator,
      validationListener: widget.validationListener,
    );
    super.initState();
  }

  void _disposeFormController() {
    widget.formController?.dispose();
  }

  @override
  void dispose() {
    autoValidationNotifier.dispose();
    _disposeFormController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: autoValidationNotifier,
      builder: (context, child) =>
          widget.fieldBuilder(context, autoValidationNotifier.errorText),
    );
  }
}
