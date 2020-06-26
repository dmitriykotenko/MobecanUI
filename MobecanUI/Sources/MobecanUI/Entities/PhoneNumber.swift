//  Copyright © 2020 Mobecan. All rights reserved.

import Foundation


public struct PhoneNumber: Codable, Equatable, CustomStringConvertible {
  
  public let digits: String
  
  public init(unsanitizedString: String) {
    self.digits = unsanitizedString.filter { $0.isDecimalDigit }
  }
  
  public var inInternationalFormat: String {
    return "+\(digits)"
  }
  
  public var description: String {
    return digits
  }
  
  public static var sample = PhoneNumber(unsanitizedString: "+7 666 13-13-13-5")
  
  public static var tinkoffBusiness = PhoneNumber(unsanitizedString: "+7 800 755-11-10")
}


private extension Character {
  
  var isDecimalDigit: Bool {
    return unicodeScalars.allSatisfy {
      CharacterSet(charactersIn: "0123456789").contains($0)
    }
  }
}
