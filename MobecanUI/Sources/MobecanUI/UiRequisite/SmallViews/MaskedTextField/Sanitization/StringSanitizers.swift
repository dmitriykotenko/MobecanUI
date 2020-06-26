import Foundation


public enum StringSanitizers {
  
  static let empty: StringSanitizer = FunctionStringSanitizer { $0 }
  
  static func prohibitedCharactersSanitizer(_ prohibited: CharacterSet) -> StringSanitizer {
    return FunctionStringSanitizer { string in
      string.filter {
        $0.unicodeScalars.filter(prohibited.contains).isEmpty
      }
    }
  }
}
