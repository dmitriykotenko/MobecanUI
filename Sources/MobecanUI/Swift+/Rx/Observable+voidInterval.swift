// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension Observable where Element == Void {

  static func voidInterval(_ interval: Duration,
                           scheduler: SchedulerType = RxSchedulers.default) -> Observable<Void> {
    randomInterval(
      average: interval,
      deviation: .zero,
      scheduler: scheduler
    )
  }
}
