# auto_validated_form

A reactive, granular, and boilerplate-free form validation package for Flutter.

## Note
This package is still under development, so if you're looking for a more mature and reliable solution with similar functionality, take a look at [reactive_forms](https://pub.dev/packages/reactive_forms).

[![pub package](https://img.shields.io/pub/v/auto_validated_form.svg)](https://pub.dev/packages/auto_validated_form)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/MohammedShuqair/auto_validated_form/blob/main/LICENSE)
[![style: flutter_lints](https://img.shields.io/badge/style-flutter__lints-40c4ff.svg)](https://pub.dev/packages/flutter_lints)

---

## Demo

<p align="center">
  <!-- Replace this URL with your hosted GIF or repository asset path (e.g., assets/demo.gif) -->
  <img src="https://raw.githubusercontent.com/MohammedShuqair/auto_validated_form/main/assets/demo.gif" alt="Auto Validated Form Demo" width="380" />
</p>

---

## Why `auto_validated_form`?

Form validation in Flutter often requires frustrating compromises:
- **Keystroke validation is annoying**: Validating immediately on the first keystroke (`AutovalidateMode.always`) complains before the user even finishes typing.
- **Unfocus validation is too late**: Validating only on unfocus or submit makes it difficult to reactively enable or disable a submit button as soon as the user enters valid data.
- **Rebuilding the whole tree**: Standard reactive forms often require listening to controllers with `setState` or rebuilding entire screens, causing unnecessary re-renders.

**`auto_validated_form` solves this with a smart validation lifecycle:**
1. **Intelligent Triggering**: Untouched fields validate when losing focus. Once touched, they validate smoothly as the user types.
2. **Granular Reactivity**: Submit buttons and error displays rebuild only when needed without re-rendering all your input fields.
3. **Clean Architecture**: Decouple validation state tracking from your presentation widgets using `ValidationStateTracker` and `AutoValidatedFormScope`.

---

## Features

- ⚡ **Smart Validation Lifecycle**: Unobtrusive on blur when empty, live on keystroke once edited.
- 🎯 **Targeted Reactive Rebuilds**: Use `AutoValidatedFormBuilder` to rebuild only the submit button or error views.
- 🔌 **Drop-in `TextField` Replacement**: `AutoValidatedTextField` supports all standard Flutter `TextField` styling and behavior.
- 🛠️ **Custom Input Support**: Wrap any custom widget with `AutoValidatedField`.
- 📊 **Powerful State Helpers**: Easily query `areAllValid`, `errorMessages`, `hasErrors`, or `errorsMap`.
- 🔄 **Form Resetting**: Reset all fields to their clean initial state in a single call.

---

## Getting Started

Add `auto_validated_form` to your `pubspec.yaml`:

```yaml
dependencies:
  auto_validated_form: ^0.0.1
```

Or install it via terminal:

```bash
flutter pub add auto_validated_form
```

Import the package in your Dart code:

```dart
import 'package:auto_validated_form/auto_validated_form.dart';
```

---

## Quick Start

Setting up an auto-validated form takes 4 easy steps:

```dart
import 'package:flutter/material.dart';
import 'package:auto_validated_form/auto_validated_form.dart';

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
    return AutoValidatedFormScope(
      validationStateTracker: _tracker,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 3. Use AutoValidatedTextField
            AutoValidatedTextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validationListener: _tracker.validationListener('email'),
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Please enter a valid email';
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
                if (value == null || value.length < 6) {
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
    );
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form Submitted!')),
    );
  }
}
```

---

## Practical Recipes

### 1. Auto-Validated Submit Button (Active / Inactive)

Keep your submit button disabled (`inactive`) until all form fields are valid, and immediately activate it as soon as validation passes—without re-rendering any of your input fields:

```dart
AutoValidatedFormBuilder(
  // Pass static children to prevent unnecessary rebuilds
  child: const Text('Submit Application'),
  builder: (context, fields, isValid, child) {
    return ElevatedButton(
      // When isValid is true, button is enabled.
      // Setting onPressed to null automatically disables (deactivates) Flutter buttons.
      onPressed: isValid ? () => _submitForm() : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isValid ? Theme.of(context).primaryColor : Colors.grey.shade400,
        foregroundColor: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isValid ? Icons.check_circle_outline : Icons.lock_outline, size: 18),
          const SizedBox(width: 8),
          child!,
        ],
      ),
    );
  },
)
```

> **Tip**: Both `isValid` and `fields.areAllValid` provide the form-wide validity status. In standard Flutter buttons (`ElevatedButton`, `FilledButton`, `TextButton`, `OutlinedButton`), passing `null` to `onPressed` automatically triggers the platform's disabled styling and touch rejection.

### 2. Centralized Error Summary List

You can display all active errors in one place (e.g., at the top or bottom of a form) using `fields.errorMessages`:

```dart
AutoValidatedFormBuilder(
  builder: (context, fields, isValid, child) {
    final errors = fields.errorMessages;
    if (errors.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final msg in errors)
            Text('• $msg', style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  },
)
```

### 3. Custom Input Widgets with `AutoValidatedField`

If you are not using standard `TextField` widgets (or want complete control over how errors are rendered), use `AutoValidatedField`:

```dart
AutoValidatedField(
  controller: _customController,
  validator: (val) => val == null || val.isEmpty ? 'Field required' : null,
  validationListener: _tracker.validationListener('custom_field'),
  fieldBuilder: (context, errorText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInputBox(controller: _customController),
        if (errorText.isNotEmpty)
          Text(errorText, style: const TextStyle(color: Colors.red)),
      ],
    );
  },
)
```

### 4. Resetting Form State

To clear your inputs and restore the tracker to its initial unvalidated state:

```dart
void _resetForm() {
  _emailController.clear();
  _passwordController.clear();
  _tracker.reset();
}
```

### 5. Custom Error Presentation on `AutoValidatedTextField`

You can hide inline error text or supply a custom error widget builder:

```dart
AutoValidatedTextField(
  controller: _controller,
  validationListener: _tracker.validationListener('field'),
  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
  // Custom error widget
  errorWidgetBuilder: (errorText) => Text(
    '⚠️ $errorText',
    style: const TextStyle(color: Colors.deepOrange, fontSize: 12),
  ),
  // Or hide the inline error entirely:
  // hideError: true,
)
```

---

## Architecture & API Overview

| Component | Role |
| :--- | :--- |
| **`ValidationStateTracker`** | Central controller holding reactive validation states (`ValueNotifier<Map<String, FieldModel>>`). |
| **`AutoValidatedFormScope`** | `InheritedWidget` that makes the `ValidationStateTracker` accessible to all descendant widgets. |
| **`AutoValidatedTextField`** | Drop-in `TextField` that wires itself to validation lifecycle listeners automatically. |
| **`AutoValidatedField`** | Generic wrapper accepting any custom widget via `fieldBuilder(context, errorText)`. |
| **`AutoValidatedFormBuilder`** | Reactive builder that rebuilds only when form validity or field states change. |
| **`FieldModelMapExtension`** | Convenience getters on `Map<String, FieldModel>` (`areAllValid`, `errorMessages`, `errorsMap`, `hasErrors`). |
| **`AutoValidatedFormController`** | Imperative controller for triggering validation manually when needed. |

### `ValidationStateTracker` Constructors

- `ValidationStateTracker.defaultFalse(List<String> ids)`: Initializes specified field IDs with unvalidated states.
- `ValidationStateTracker.byList(List<FieldModel> fields)`: Initializes tracker with a list of custom `FieldModel` instances.
- `ValidationStateTracker.byFields(Map<String, FieldModel> fields)`: Initializes tracker with an explicit map of `FieldModel` instances.

---

## Comparison: Traditional Flutter vs. `auto_validated_form`

Check out the [`example/`](https://github.com/MohammedShuqair/auto_validated_form/tree/main/example) directory for a complete, runnable app demonstrating:
- Side-by-side comparison between Flutter's default `Form`/`TextFormField` approach and `auto_validated_form`.
- How `auto_validated_form` eliminates boilerplate listener chains and timing delays.

To run the example app:

```bash
cd example
flutter run
```

---

## Contributing

Contributions, issues, and feature requests are welcome!  
Feel free to open an issue or pull request on [GitHub](https://github.com/MohammedShuqair/auto_validated_form).

---

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/MohammedShuqair/auto_validated_form/blob/main/LICENSE) file for details.
