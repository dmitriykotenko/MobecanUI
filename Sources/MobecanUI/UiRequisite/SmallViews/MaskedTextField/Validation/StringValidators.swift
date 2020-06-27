/// Validators for different kinds of strings.
public enum StringValidators {
  
  static let empty: StringValidator = FunctionStringValidator { _ in true }
  
  static let partialDate: StringValidator = FunctionStringValidator { string in
    regexCheck(string, pattern: "^[0-9]{0,8}$")
  }
  
  static let partialRussianPassportNumber: StringValidator = FunctionStringValidator { string in
    regexCheck(string, pattern: "^[0-9]{0,10}$")
  }
  
  static let partialInternationalPassportNumber: StringValidator = FunctionStringValidator { string in
    regexCheck(string, pattern: "^[0-9]{0,9}$")
  }
  
  static let partialBirthCertificateNumber: StringValidator = FunctionStringValidator { string in
    let uppercasedString = string.uppercased()
    
    let romanDigitsSection = "[" + String.romanDigits + "]{0,10}"
    let cyrillicLettersSection = "[" + String.cyrillicLetters + "]{0,2}"
    let digitsSection = "[0-9]{0,6}"
    
    return regexCheck(
      string,
      pattern: "^" + romanDigitsSection + cyrillicLettersSection + digitsSection + "$"
    )
  }
  
  static let partialForeignDocumentNumber: StringValidator = FunctionStringValidator { string in
    /// Only spaces are prohibited.
    return regexCheck(string, pattern: "^\\S*$")
  }
  
  static func maximumLengthValidator(_ length: Int) -> StringValidator {
    return FunctionStringValidator { string in string.count <= length }
  }
  
  static func regexValidator(_ pattern: String) -> StringValidator {
    return FunctionStringValidator { string in regexCheck(string, pattern: pattern) }
  }
}


private func regexCheck(_ string: String,
                        pattern: String) -> Bool {
  return string.range(of: pattern, options: .regularExpression) != nil
}
