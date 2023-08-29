// Copyright © 2023 Mobecan. All rights reserved.

import XCTest
@testable import MobecanUI

import RxSwift
import RxTest
import SwiftDateTime


public extension Recorded {

  func plus(timeOffset: TestTime) -> Self {
    .init(time: time + timeOffset, value: value)
  }

  func minus(timeOffset: TestTime) -> Self {
    plus(timeOffset: -timeOffset)
  }
}
