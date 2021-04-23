//  Copyright © 2020 Mobecan. All rights reserved.


public class NameFormatter: StringFormatter {
  
  public init() {}
  
  public func format(_ string: String) -> String {
    string.trimmingCharacters(in: .whitespaces)
  }
}


public class PhoneNumberFormatter: StringFormatter {
  
  public init() {}

  public func format(_ string: String) -> String {
    let s1 = string.prefix(2) + " "
    let s2 = string.dropFirst(2).prefix(3) + " "
    let s3 = string.dropFirst(5).prefix(3) + "-"
    let s4 = string.dropFirst(8).prefix(2) + "-"
    let s5 = string.dropFirst(10)

    return String(s1 + s2 + s3 + s4 + s5)
  }
}


public extension StringFormatter {

  static func name() -> StringFormatter { NameFormatter() }

  static func phoneNumber() -> StringFormatter { PhoneNumberFormatter() }
}
