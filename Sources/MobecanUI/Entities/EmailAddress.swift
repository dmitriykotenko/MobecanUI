//  Copyright © 2020 Mobecan. All rights reserved.


public struct EmailAddress: Codable, Equatable, CustomStringConvertible {
  
  public let string: String
  
  public init(unsanitizedString: String) {
    self.string = unsanitizedString.lowercased()
  }
  
  public static func from(unsanitizedString: String) -> EmailAddress? {
    let stringStart = "^"
    let stringEnd = "$"
    let letterOrDigit = "[a-zA-Z0-9]"
    let character = "[a-zA-Z0-9._-]"
    let dot = "\\."
    
    let regex = "\(stringStart)\(character)+@\(character)+\(dot)+\(letterOrDigit)+\(stringEnd)"
    
    switch unsanitizedString.range(of: regex, options: .regularExpression) {
    case nil:
      return nil
    case _?:
      return EmailAddress(unsanitizedString: unsanitizedString)
    }
  }
  
  public var description: String { string }
  
  public static let sample = EmailAddress(unsanitizedString: "mowgli@jungle.in")
}
