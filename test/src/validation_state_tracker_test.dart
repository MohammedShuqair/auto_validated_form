import 'package:auto_validated_form/auto_validated_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ValidationStateTracker', () {
    late ValidationStateTracker tracker;

    setUp(() {
      tracker =
          ValidationStateTracker.defaultFalse(['name', 'email', 'address']);
    });

    tearDown(() {
      tracker.dispose();
    });

    test('initializes with unvalidated default values', () {
      final values = tracker.formValidationNotifier.value;

      expect(values.length, 3);
      expect(values.keys.toList(), equals(['name', 'email', 'address']));
      expect(values['name']?.validated, isFalse);
      expect(values['name']?.errorText, isEmpty);
      expect(tracker.isValid, isFalse);
    });

    test('supports passing a List of FieldModel via byList constructor', () {
      final listTracker = ValidationStateTracker.byList([
        const FieldModel(id: 'first', errorText: '', validated: false),
        const FieldModel(id: 'second', errorText: 'Error', validated: true),
      ]);

      final values = listTracker.formValidationNotifier.value;
      expect(values.length, 2);
      expect(values.keys.toList(), equals(['first', 'second']));
      expect(values['first']?.validated, isFalse);
      expect(values['second']?.errorText, equals('Error'));
      expect(listTracker.isValid, isFalse);

      listTracker.dispose();
    });

    test('transitions unvalidated field to validated=true on first valid input',
        () {
      // User types valid input on the very first try (error message is empty)
      tracker.validate('name', '');

      final field = tracker.formValidationNotifier.value['name']!;
      expect(field.validated, isTrue,
          reason:
              'Field must be marked validated even if errorText starts and stays empty');
      expect(field.errorText, isEmpty);
      expect(field.isValid, isTrue);
    });

    test('becomes valid when all fields are successfully validated', () {
      expect(tracker.isValid, isFalse);

      tracker.validate('name', '');
      expect(tracker.isValid, isFalse);

      tracker.validate('email', '');
      expect(tracker.isValid, isFalse);

      tracker.validate('address', '');
      expect(tracker.isValid, isTrue);
    });

    test('sets error message and marks field as invalid', () {
      tracker.validate('email', 'Invalid email format');

      final field = tracker.formValidationNotifier.value['email']!;
      expect(field.validated, isTrue);
      expect(field.errorText, 'Invalid email format');
      expect(field.hasError, isTrue);
      expect(field.isValid, isFalse);
      expect(tracker.isValid, isFalse);
    });

    test(
        'preserves original insertion order when fields are validated out-of-order',
        () {
      // Validate 'address' first, then 'name', then 'email'
      tracker.validate('address', '');
      tracker.validate('name', 'Name error');
      tracker.validate('email', '');

      final currentKeys = tracker.formValidationNotifier.value.keys.toList();
      expect(currentKeys, equals(['name', 'email', 'address']),
          reason:
              'Map must preserve initial insertion order regardless of update sequence');
    });

    test('validationListener correctly invokes validate callback', () {
      final listener = tracker.validationListener('name');
      expect(listener, isNotNull);

      listener!('New error');
      expect(tracker.formValidationNotifier.value['name']?.errorText,
          equals('New error'));
    });

    test('reset reverts fields back to initial default state', () {
      tracker.validate('name', 'Error');
      tracker.validate('email', '');
      expect(tracker.formValidationNotifier.value['name']?.hasError, isTrue);

      tracker.reset();

      final resetValues = tracker.formValidationNotifier.value;
      expect(resetValues['name']?.validated, isFalse);
      expect(resetValues['name']?.errorText, isEmpty);
      expect(resetValues['email']?.validated, isFalse);
      expect(tracker.isValid, isFalse);
    });
  });
}
