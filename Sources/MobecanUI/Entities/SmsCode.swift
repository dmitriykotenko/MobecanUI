//  Copyright © 2020 Mobecan. All rights reserved.


public struct SmsCode: Equatable, Hashable, Codable, Lensable, CustomStringConvertible {
  
  public let digits: String
  
  public init(_ digits: String) {
    self.digits = digits
  }
  
  public var description: String { digits }
  
  public static var sample = SmsCode("")
}
