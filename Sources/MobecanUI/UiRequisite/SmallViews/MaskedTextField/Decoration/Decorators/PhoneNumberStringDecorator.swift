/// Decorates a phone number entered by the user to make it more human-readable.
class PhoneNumberStringDecorator: StringDecorator {
  
  private let plusSevenDecorator = TemplateStringDecorator(template: "__ ___ ___-__-__")
  private let eightDecorator = TemplateStringDecorator(template: "_ ___ ___-__-__")
  private let emptyDecorator = EmptyStringDecorator()
  
  func decorate(_ string: String) -> DecoratedString {
    if string.hasPrefix("+7") {
      return plusSevenDecorator.decorate(string)
    } else if string.hasPrefix("8") {
      return eightDecorator.decorate(string)
    } else {
      return emptyDecorator.decorate(string)
    }
  }
}
