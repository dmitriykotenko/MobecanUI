// Copyright © 2020 Mobecan. All rights reserved.

import NonEmpty
import RxSwift


@DerivesAutoGeneratable
@TryInit
public struct Age: Equatable, Hashable, Codable, Lensable, CustomStringConvertible {
  
  public var years: Int

  public init(years: Int) {
    self.years = years
  }

  public var description: String {
    (years == 1) ? "1 year" :
      (years == -1) ? "-1 year" :
      "\(years) years"
  }
}


extension Age: Comparable {

  public static func < (this: Age, that: Age) -> Bool {
    this.years < that.years
  }
}
