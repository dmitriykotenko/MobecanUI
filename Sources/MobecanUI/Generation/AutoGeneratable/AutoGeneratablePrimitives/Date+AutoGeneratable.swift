// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import RxSwift


extension Date: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> {
    .pure {
      let bounds = Date.distantPast...Date.distantFuture
      let timeInterval = TimeInterval.random(in: bounds.mapBounds(\.timeIntervalSince1970))
      return Date(timeIntervalSince1970: timeInterval)
    }
  }
}
