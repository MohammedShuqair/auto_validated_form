import 'package:auto_validated_form/auto_validated_form.dart';
import 'package:flutter/material.dart';

class QuickStartForm extends StatefulWidget {
  const QuickStartForm({super.key});

  @override
  State<QuickStartForm> createState() => _QuickStartFormState();
}

class _QuickStartFormState extends State<QuickStartForm> {
  // 1. Initialize the tracker with your field IDs
  late final ValidationStateTracker _tracker;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tracker = ValidationStateTracker.defaultFalse(['email', 'password']);
  }

  @override
  void dispose() {
    _tracker.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 2. Wrap your form in AutoValidatedFormScope
    return Scaffold(
      body: AutoValidatedFormScope(
        validationStateTracker: _tracker,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // 3. Use AutoValidatedTextField
              AutoValidatedTextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validationListener: _tracker.validationListener('email'),
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
              const SizedBox(height: 16),
              AutoValidatedTextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validationListener: _tracker.validationListener('password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // 4. Reactively enable the submit button
              AutoValidatedFormBuilder(
                builder: (context, fields, isValid, child) {
                  return ElevatedButton(
                    onPressed: isValid ? _submit : null,
                    child: child!,
                  );
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form Submitted!')),
    );
  }
}
