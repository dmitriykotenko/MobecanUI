/// Validators for different kinds of strings.
public enum StringValidators {
  
  public static let empty: StringValidator = FunctionStringValidator { _ in true }
  
  public static let partialDate: StringValidator = regexValidator("^[0-9]{0,8}$")
  
  public static let partialRussianPassportNumber: StringValidator = regexValidator("^[0-9]{0,10}$")

  public static let partialInternationalPassportNumber: StringValidator = regexValidator("^[0-9]{0,9}$")

  public static let partialBirthCertificateNumber: StringValidator = FunctionStringValidator { change in
    let romanDigitsSection = "[" + String.romanDigits + "]{0,10}"
    let cyrillicLettersSection = "[" + String.cyrillicLetters + "]{0,2}"
    let digitsSection = "[0-9]{0,6}"
    
    return change.replacementString.isEmpty || regexCheck(
      change.newText,
      pattern: "^" + romanDigitsSection + cyrillicLettersSection + digitsSection + "$"
    )
  }
  
  public static let partialForeignDocumentNumber: StringValidator = FunctionStringValidator { change in
    change.replacementString.isEmpty
    || regexCheck(change.newText, pattern: "^\\S*$") // only spaces are prohibited
  }
  
  public static func maximumLengthValidator(_ length: Int) -> StringValidator {
    FunctionStringValidator { change in
      change.replacementString.isEmpty || change.newText.count <= length
    }
  }
  
  public static func regexValidator(_ pattern: String) -> StringValidator {
    FunctionStringValidator { change in
      change.replacementString.isEmpty || regexCheck(change.newText, pattern: pattern)
    }
  }
}


private func regexCheck(_ string: String,
                        pattern: String) -> Bool {
  string.range(of: pattern, options: .regularExpression) != nil
}
