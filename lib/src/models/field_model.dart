import 'package:equatable/equatable.dart';

/// Represents the validation state of an individual form field.
class FieldModel extends Equatable {
  /// The unique identifier of the field.
  final String id;

  /// Whether this field has been evaluated by its validator.
  final bool validated;

  /// The error message for the field, or an empty string if valid.
  final String errorText;

  /// Creates a [FieldModel] with the specified [id], [validated] status, and [errorText].
  const FieldModel({
    required this.id,
    this.validated = false,
    this.errorText = '',
  });

  /// Returns a copy of this [FieldModel] with the given fields replaced.
  FieldModel copyWith({String? id, bool? validated, String? errorText}) {
    return FieldModel(
      id: id ?? this.id,
      validated: validated ?? this.validated,
      errorText: errorText ?? this.errorText,
    );
  }

  /// Whether the field currently has an error message.
  bool get hasError => errorText.isNotEmpty;

  /// Whether the field has been validated and contains no errors.
  bool get isValid => validated && !hasError;

  @override
  List<Object?> get props => [id, validated, errorText];
}
