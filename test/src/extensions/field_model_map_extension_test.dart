import 'package:auto_validated_form/auto_validated_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FieldModelMapExtension', () {
    test('errorMessages returns list of all non-empty error messages', () {
      final map = {
        'f1': const FieldModel(id: 'f1', errorText: 'Error 1', validated: true),
        'f2': const FieldModel(id: 'f2', errorText: '', validated: true),
        'f3': const FieldModel(id: 'f3', errorText: 'Error 3', validated: true),
      };

      expect(map.errorMessages, equals(['Error 1', 'Error 3']));
    });

    test('hasErrors returns true only when at least one field has an error', () {
      final mapWithErrors = {
        'f1': const FieldModel(id: 'f1', errorText: 'Error', validated: true),
        'f2': const FieldModel(id: 'f2', errorText: '', validated: true),
      };
      expect(mapWithErrors.hasErrors, isTrue);

      final mapWithoutErrors = {
        'f1': const FieldModel(id: 'f1', errorText: '', validated: true),
        'f2': const FieldModel(id: 'f2', errorText: '', validated: false),
      };
      expect(mapWithoutErrors.hasErrors, isFalse);
    });

    test('areAllValid verifies all fields are validated and error-free', () {
      final validMap = {
        'f1': const FieldModel(id: 'f1', errorText: '', validated: true),
        'f2': const FieldModel(id: 'f2', errorText: '', validated: true),
      };
      expect(validMap.areAllValid, isTrue);

      final unvalidatedMap = {
        'f1': const FieldModel(id: 'f1', errorText: '', validated: true),
        'f2': const FieldModel(id: 'f2', errorText: '', validated: false),
      };
      expect(unvalidatedMap.areAllValid, isFalse);

      final errorMap = {
        'f1': const FieldModel(id: 'f1', errorText: 'Err', validated: true),
      };
      expect(errorMap.areAllValid, isFalse);

      final emptyMap = <String, FieldModel>{};
      expect(emptyMap.areAllValid, isFalse);
    });

    test('errorsMap returns map of only fields with active errors', () {
      final map = {
        'name': const FieldModel(id: 'name', errorText: 'Required', validated: true),
        'email': const FieldModel(id: 'email', errorText: '', validated: true),
        'age': const FieldModel(id: 'age', errorText: 'Must be 18+', validated: true),
      };

      expect(
        map.errorsMap,
        equals({'name': 'Required', 'age': 'Must be 18+'}),
      );
    });

    test('fieldList returns fields preserving insertion order', () {
      final map = {
        'first': const FieldModel(id: 'first'),
        'second': const FieldModel(id: 'second'),
        'third': const FieldModel(id: 'third'),
      };

      expect(map.fieldList.map((e) => e.id).toList(), equals(['first', 'second', 'third']));
    });
  });
}
