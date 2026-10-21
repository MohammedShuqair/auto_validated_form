import 'package:auto_validated_form/src/models/field_model.dart';

/// Extension on [Map<String, FieldModel>] providing convenience getters and helpers
/// for form validation states.
extension FieldModelMapExtension on Map<String, FieldModel> {
  /// The list of non-empty error messages across all fields.
  List<String> get errorMessages =>
      values.where((f) => f.hasError).map((f) => f.errorText).toList();

  /// Whether any field currently contains an error message.
  bool get hasErrors => values.any((f) => f.hasError);

  /// Whether all fields have been evaluated and are free of errors.
  ///
  /// Returns `false` if the map is empty.
  bool get areAllValid => isNotEmpty && values.every((f) => f.isValid);

  /// A map containing only fields that have active validation errors.
  Map<String, String> get errorsMap => {
        for (final entry in entries)
          if (entry.value.hasError) entry.key: entry.value.errorText,
      };

  /// The list of all [FieldModel] values in insertion order.
  List<FieldModel> get fieldList => values.toList();
}
