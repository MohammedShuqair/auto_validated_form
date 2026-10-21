import 'package:auto_validated_form/src/models/field_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FieldModel', () {
    test('defaults to unvalidated with empty error text', () {
      const model = FieldModel(id: 'email');

      expect(model.id, 'email');
      expect(model.validated, isFalse);
      expect(model.errorText, isEmpty);
      expect(model.hasError, isFalse);
      expect(model.isValid, isFalse);
    });

    test('correctly evaluates hasError and isValid states', () {
      const validModel = FieldModel(
        id: 'email',
        validated: true,
        errorText: '',
      );
      expect(validModel.hasError, isFalse);
      expect(validModel.isValid, isTrue);

      const invalidModel = FieldModel(
        id: 'email',
        validated: true,
        errorText: 'Invalid email',
      );
      expect(invalidModel.hasError, isTrue);
      expect(invalidModel.isValid, isFalse);

      const unvalidatedWithNoError = FieldModel(
        id: 'email',
        validated: false,
        errorText: '',
      );
      expect(unvalidatedWithNoError.hasError, isFalse);
      expect(unvalidatedWithNoError.isValid, isFalse);
    });

    test('copyWith updates specified fields and preserves untouched ones', () {
      const original = FieldModel(
        id: 'username',
        validated: false,
        errorText: '',
      );

      final updated = original.copyWith(
        validated: true,
        errorText: 'Too short',
      );

      expect(updated.id, 'username');
      expect(updated.validated, isTrue);
      expect(updated.errorText, 'Too short');

      final copiedSame = original.copyWith();
      expect(copiedSame, equals(original));
    });

    test('equality and props work as expected with Equatable', () {
      const model1 = FieldModel(id: 'a', validated: true, errorText: 'err');
      const model2 = FieldModel(id: 'a', validated: true, errorText: 'err');
      const model3 = FieldModel(id: 'a', validated: false, errorText: 'err');

      expect(model1, equals(model2));
      expect(model1.hashCode, equals(model2.hashCode));
      expect(model1, isNot(equals(model3)));
    });
  });
}
