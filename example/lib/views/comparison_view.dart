import 'package:flutter/material.dart';

import 'auto_validated_form_view.dart';
import 'flutter_form_validation_view.dart';

class ComparisonView extends StatelessWidget {
  const ComparisonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Form Validation"),
      ),
      body: SingleChildScrollView(
        key: const Key("scroll_view"),
        child: SafeArea(
          child: Column(
            children: const [
              FlutterFormValidationView(),
              AutoValidatedFormView(),
            ],
          ),
        ),
      ),
    );
  }
}
