//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import SwiftDateTime
import UIKit


public protocol TemporalView: UIView {
  
  var clock: AnyObserver<Clock?> { get }
}


public extension TemporalView {

  func with(clock: Clock) -> Self {
    self.clock.onNext(clock)
    return self
  }
}
