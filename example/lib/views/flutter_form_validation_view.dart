import 'dart:async';

import 'package:flutter/material.dart';

/// This view shows how we could implement the auto validation scenario in flutter
/// without using any external library, this is why I built [auto_validated_form] package :)
class FlutterFormValidationView extends StatefulWidget {
  const FlutterFormValidationView({super.key});

  @override
  State<FlutterFormValidationView> createState() =>
      _FlutterFormValidationViewState();
}

class _FlutterFormValidationViewState extends State<FlutterFormValidationView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _validate() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Validation passed! ${_nameController.text} ${_emailController.text} ${_addressController.text}",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Validation failed!')));
    }
  }

  void _reset() {
    _formKey.currentState?.reset();
  }

  /// The [validate] method in this scenario has a delay of 1 ch
  /// example:
  /// field value: moh
  /// user type a
  /// the [validate] method validate moh value
  /// you can use [Timer] with [Duration] to solve this behaviour
  /// but I don't thing this is a valid solution so I used [didChange] method to
  /// update field value
  void _listenToName() {
    _nameController.addListener(() {
      _formKey.currentState!.fields
          .elementAt(0)
          .didChange(_nameController.text);

      _formKey.currentState!.fields.elementAt(0).validate();
    });
  }

  void _listenToEmail() {
    _emailController.addListener(() {
      _formKey.currentState!.fields
          .elementAt(1)
          .didChange(_emailController.text);
      _formKey.currentState!.fields.elementAt(1).validate();
    });
  }

  void _listenToAddress() {
    _addressController.addListener(() {
      _formKey.currentState!.fields
          .elementAt(2)
          .didChange(_addressController.text);
      _formKey.currentState!.fields.elementAt(2).validate();
    });
  }

  @override
  void initState() {
    _listenToName();
    _listenToEmail();
    _listenToAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: Column(
          mainAxisAlignment: .center,
          spacing: 16,
          children: [
            Text(
              "Flutter Form Validation Example",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),

            TextFormField(
              decoration: InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
              controller: _addressController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),

            Row(
              spacing: 8,
              mainAxisAlignment: .center,
              children: [
                ElevatedButton(onPressed: _validate, child: Text("Validate")),
                ElevatedButton(onPressed: _reset, child: Text("Reset")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
