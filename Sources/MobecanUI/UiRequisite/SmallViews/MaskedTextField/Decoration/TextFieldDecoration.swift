/// Kind of decoration for ``MaskedTextField``.
///
/// ``.none`` means no decoration at all
///
/// ``.template`` option is suitable for most cases
///
/// For some elaborate cases custom decorator can be specified using ``.custom`` option.
public enum TextFieldDecoration {
  
  /// No decoration.
  case none
  
  /// Template for decoration of ``MaskedTextField``.
  /// Underscores represent text entered by the user.
  /// Every character except underscore considered auxiliary.
  case template(String, suffix: String? = nil)

  /// Custom decorator for ``MaskedTextField``.
  case custom(StringDecorator)
  
  func parse() -> StringDecorator {
    switch self {
    case .none:
      return EmptyStringDecorator()
    case .template(let template, let suffix):
      return TemplateStringDecorator(template: template, globalSuffix: suffix)
    case .custom(let customDecorator):
      return customDecorator
    }
  }
}
