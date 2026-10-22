## 0.0.1

* Initial release of `auto_validated_form`:
  * **Smart Validation Lifecycle**: Unobtrusive validation on unfocus for untouched fields; reactive keystroke validation once edited.
  * **`ValidationStateTracker`**: Centralized validation controller supporting `.defaultFalse()`, `.byList()`, `.byFields()`, and form reset capabilities.
  * **`AutoValidatedFormScope`**: `InheritedWidget` to scope and share `ValidationStateTracker` across the widget hierarchy.
  * **`AutoValidatedFormBuilder`**: Targeted reactive builder widget to selectively rebuild UI elements (such as submit buttons or error summaries) without rebuilding input fields.
  * **`AutoValidatedTextField`**: Drop-in `TextField` wrapper supporting full Flutter `TextField` configuration and customizable error widgets.
  * **`AutoValidatedField`**: Generic form input wrapper for creating custom inputs and layout builders.
  * **`AutoValidatedFormController`**: Imperative controller to manually trigger field validation.
  * **`FieldModelMapExtension`**: Utility getters on `Map<String, FieldModel>` (`areAllValid`, `errorMessages`, `hasErrors`, `errorsMap`, `fieldList`).
  * **Example & Documentation**: Comprehensive Quick Start guide, interactive example app, and practical usage recipes.
