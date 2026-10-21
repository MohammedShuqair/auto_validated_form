import 'package:auto_validated_form/auto_validated_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AutoValidatedFormBuilder', () {
    testWidgets('renders using inherited AutoValidatedFormScope and rebuilds on change', (tester) async {
      final tracker = ValidationStateTracker.defaultFalse(['email']);

      await tester.pumpWidget(
        MaterialApp(
          home: AutoValidatedFormScope(
            validationStateTracker: tracker,
            child: AutoValidatedFormBuilder(
              builder: (context, fields, isValid, child) {
                return Column(
                  children: [
                    Text('Valid: $isValid'),
                    Text('Email error: ${fields['email']?.errorText}'),
                    for (final err in fields.errorMessages) Text('Err: $err'),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Valid: false'), findsOneWidget);
      expect(find.text('Email error: '), findsOneWidget);

      tracker.validate('email', 'Invalid email address');
      await tester.pump();

      expect(find.text('Valid: false'), findsOneWidget);
      expect(find.text('Email error: Invalid email address'), findsOneWidget);
      expect(find.text('Err: Invalid email address'), findsOneWidget);

      tracker.validate('email', '');
      await tester.pump();

      expect(find.text('Valid: true'), findsOneWidget);
      expect(find.text('Email error: '), findsOneWidget);
      expect(find.text('Err: Invalid email address'), findsNothing);

      tracker.dispose();
    });

    testWidgets('renders using explicit value notifier without AutoValidatedFormScope', (tester) async {
      final notifier = ValueNotifier<Map<String, FieldModel>>({
        'name': const FieldModel(id: 'name', validated: true, errorText: ''),
      });

      await tester.pumpWidget(
        MaterialApp(
          home: AutoValidatedFormBuilder(
            value: notifier,
            builder: (context, fields, isValid, child) {
              return Text('Form Valid: $isValid, Name: ${fields['name']?.id}');
            },
          ),
        ),
      );

      expect(find.text('Form Valid: true, Name: name'), findsOneWidget);
      notifier.dispose();
    });

    testWidgets('throws StateError when neither value nor AutoValidatedFormScope is provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AutoValidatedFormBuilder(
            builder: (context, fields, isValid, child) => const SizedBox(),
          ),
        ),
      );

      expect(tester.takeException(), isA<StateError>());
    });
  });
}
