// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import RxSwift


extension Data: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> {
    .pure {
      let count = Int.random(in: 0...200)
      let bytes = (0..<count).map { _ in UInt8.random(in: UInt8.min...UInt8.max) }
      return Data(bytes)
    }
  }
}
