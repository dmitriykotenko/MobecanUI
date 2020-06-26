/// Kind of decoration for MaskedTextField:
/// .none means no decoration at all;
/// .template option is suitable for most cases;
/// for some elaborate cases custom decorator can be specified using .custom option.
public enum TextFieldDecoration {
  
  /// No decoration.
  case none
  
  /// Template for decoration of MaskedTextField.
  /// Underscores represent text entered by the user.
  /// Every character except underscore considered auxiliary.
  case template(String)
  
  /// Custom decorator for MaskedTextField.
  case custom(StringDecorator)
  
  func parse() -> StringDecorator {
    switch self {
    case .none:
      return EmptyStringDecorator()
    case .template(let template):
      return TemplateStringDecorator(template: template)
    case .custom(let customDecorator):
      return customDecorator
    }
  }
}
