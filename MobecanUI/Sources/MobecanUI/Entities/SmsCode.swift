//  Copyright © 2020 Mobecan. All rights reserved.


public struct SmsCode: Codable, Equatable, CustomStringConvertible {
  
  public let digits: String
  
  public init(_ digits: String) {
    self.digits = digits
  }
  
  public var description: String {
    return digits
  }
  
  public static var sample = SmsCode("")
}
