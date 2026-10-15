import 'package:auto_validated_form/auto_validated_form.dart';
import 'package:flutter/material.dart';

class AutoValidatedField extends StatefulWidget {
  const AutoValidatedField({
    super.key,
    this.focusNode,
    required this.controller,
    this.validator,
    this.validationListener,
    required this.fieldBuilder,
    this.formController,
  });

  final FocusNode? focusNode;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValidationListener? validationListener;
  final Widget Function(BuildContext context, String errorText) fieldBuilder;
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
