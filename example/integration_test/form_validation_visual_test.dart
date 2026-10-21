import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AutoValidatedForm Visual Integration Test', () {
    testWidgets('visually walks through form validation states on emulator', (
      tester,
    ) async {
      // Helper function to allow human observation between test steps
      Future<void> observe(String stepDescription, [int ms = 1500]) async {
        await tester.pumpAndSettle();
        // ignore: avoid_print
        print('👉 STEP: $stepDescription');
        await Future.delayed(Duration(milliseconds: ms));
      }

      // Launch the example app
      await tester.pumpWidget(const MyApp());
      await observe('App launched, scrolling to Auto Validated Form');

      // Scroll to the AutoValidatedFormView section
      final nameField = find.byKey(const Key('name_field'));
      // await tester.scrollUntilVisible(nameField, 200);
      await observe('Auto Validated Form view is visible');

      // Step 1: Type valid name
      await tester.enterText(nameField, 'Jane Doe');
      await observe('Entered valid name "Jane Doe"');

      // Step 2: Type invalid email
      final emailField = find.byKey(const Key('email_field'));
      await tester.enterText(emailField, 'invalid-email');
      await observe('Entered invalid email "invalid-email" - error appears');

      expect(find.text('Please enter a valid email address'), findsNWidgets(2));

      // Step 3: Correct the email address
      await tester.enterText(emailField, 'jane@example.com');
      await observe('Corrected email to "jane@example.com" - error clears');

      expect(find.text('Please enter a valid email address'), findsNothing);

      // Step 4: Type address
      final addressField = find.byKey(const Key('address_field'));
      await tester.enterText(addressField, '742 Evergreen Terrace');
      await observe(
        'Entered address "742 Evergreen Terrace" - all fields valid',
      );

      // Step 5: Tap Validate button
      final validateButton = find.byKey(const Key('validate_button'));
      final scrollView = find.byKey(const Key('scroll_view'));
      // scroll to the button
      await tester.dragUntilVisible(
        validateButton,
        scrollView,
        Offset(0, -500),
      );
      await tester.tap(validateButton);
      await observe(
        'Tapped "Validate" button - success snackbar displayed',
        2000,
      );

      expect(find.textContaining('Validation passed!'), findsOneWidget);

      // Step 6: Tap Reset button
      final resetButton = find.byKey(const Key('reset_button'));
      await tester.tap(resetButton);
      await observe(
        'Tapped "Reset" button - form reset to initial unvalidated state',
        2000,
      );

      expect(find.text('Jane Doe'), findsNothing);
    });
  });
}
