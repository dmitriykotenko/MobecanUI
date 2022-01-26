// Copyright © 2021 Mobecan. All rights reserved.

import Foundation
import CoreGraphics


public extension String {

  var asInt: Int? { Int(self) }
  var asUInt32: UInt32? { UInt32(self) }
  var asInt64: Int64? { Int64(self) }
  var asDouble: Double? { Double(self) }

  var asCGFloat: CGFloat? {
    asDouble.map { CGFloat($0) }
  }

  var asDecimal: Decimal? { Decimal(string: self) }

  var asNSNumber: NSNumber? {
    NumberFormatter().number(from: self)
  }
}
