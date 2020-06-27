/// Kind of validation for MaskedTextField:
///
/// .none means no validation at all;
/// .maximumLength means that strings which are longer that specified value will be considered invalid;
/// .regex means that some regular expression will be used for validation;
/// .function means that custom function will be used for validation.
/// .custom means that custom validator will be used.
///
/// In either case, nil is always considered valid string.
public enum TextFieldValidation {

  /// Do not perform any validation.
  case none
  
  /// Validation for MaskedTextField which returns true if text length does not exceed specified value.
  case maximumLength(Int)
  
  /// Validation for MaskedTextField which returns true if and only if a text matches given regular expression.
  case regex(String)
  
  /// Validation for MaskedTextField which uses given function as validator.
  case function((String) -> Bool)

  /// Custom validation for MaskedTextField.
  case custom(StringValidator)
  
  func parse() -> StringValidator {
    switch self {
    case .none:
      return StringValidators.empty
    case .maximumLength(let length):
      return StringValidators.maximumLengthValidator(length)
    case .regex(let pattern):
      return StringValidators.regexValidator(pattern)
    case .function(let function):
      return FunctionStringValidator(function: function)
    case .custom(let customValidator):
      return customValidator
    }
  }
}
