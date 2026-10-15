import 'package:flutter/material.dart';

import 'views/auto_validated_form_view.dart';
import 'views/flutter_form_validation_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Form Validation"),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: const [
                FlutterFormValidationView(),
                AutoValidatedFormView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
