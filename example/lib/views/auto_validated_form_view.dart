import 'package:auto_validated_form/auto_validated_form.dart';
import 'package:example/enums.dart';
import 'package:flutter/material.dart';

class AutoValidatedFormView extends StatefulWidget {
  const AutoValidatedFormView({super.key});

  @override
  State<AutoValidatedFormView> createState() => _AutoValidatedFormViewState();
}

class _AutoValidatedFormViewState extends State<AutoValidatedFormView> {
  late final ValidationStateTracker validationStateTracker;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    validationStateTracker = ValidationStateTracker.defaultFalse([
      ValidationKey.name.name,
      ValidationKey.email.name,
      ValidationKey.address.name,
    ]);
    super.initState();
  }

  void _validate(bool isValid) {
    if (isValid) {
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

  void _onTapOutSide(PointerDownEvent event) {
    FocusScope.of(context).unfocus();
  }

  void _reset() {
    _nameController.clear();
    _emailController.clear();
    _addressController.clear();
    validationStateTracker.reset();
  }

  @override
  Widget build(BuildContext context) {
    return AutoValidatedFormScope(
      validationStateTracker: validationStateTracker,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: .center,
          spacing: 16,
          children: [
            Text(
              "Auto Validated Form Validation Example",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            AutoValidatedTextField(
              controller: _nameController,
              onTapOutside: _onTapOutSide,

              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
              validationListener: validationStateTracker.validationListener(
                ValidationKey.name.name,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            AutoValidatedTextField(
              controller: _emailController,
              onTapOutside: _onTapOutSide,

              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              validationListener: validationStateTracker.validationListener(
                ValidationKey.email.name,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
              },
            ),
            AutoValidatedTextField(
              controller: _addressController,
              onTapOutside: _onTapOutSide,
              decoration: InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
              validationListener: validationStateTracker.validationListener(
                ValidationKey.address.name,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),

            AutoValidatedFormBuilder(
              builder: (_, Map<String, String> validationState, _, _) {
                List<String> errorMessages = validationState.values
                    .where((message) => message.isNotEmpty)
                    .toList();
                return Align(
                  alignment: .centerStart,
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      for (String message in errorMessages) ...[
                        Text(message, style: TextStyle(color: Colors.red)),
                      ],
                    ],
                  ),
                );
              },
            ),

            Row(
              spacing: 8,
              mainAxisAlignment: .center,
              children: [
                AutoValidatedFormBuilder(
                  builder: (_, _, isValid, child) {
                    return ElevatedButton(
                      onPressed: () => _validate(isValid),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isValid ? null : Colors.grey,
                      ),
                      child: child!,
                    );
                  },
                  child: Text("Validate"),
                ),
                ElevatedButton(onPressed: _reset, child: Text("Reset")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
