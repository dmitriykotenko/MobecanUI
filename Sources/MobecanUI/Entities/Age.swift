//  Copyright © 2020 Mobecan. All rights reserved.


public struct Age: Equatable, Codable, Comparable, CustomStringConvertible {
  
  public let years: Int

  public init(years: Int) {
    self.years = years
  }

  public var description: String {
    (years == 1) ? "1 year" :
      (years == -1) ? "-1 year" :
      "\(years) years"
  }
  
  public static func < (this: Age, that: Age) -> Bool {
    this.years < that.years
  }
}
