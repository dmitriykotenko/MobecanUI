//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension ObservableType where Element: RxAbstractInteger {
  
  static func timer(_ dueTime: Duration,
                    period: Duration? = nil,
                    scheduler: SchedulerType) -> Observable<Element> {
    return timer(
      dueTime.toRxTimeInterval,
      period: period?.toRxTimeInterval,
      scheduler: scheduler
    )
  }
}


public extension ObservableType where Element == Void {
  
  static func voidTimer(_ dueTime: Duration,
                        period: Duration? = nil,
                        scheduler: SchedulerType) -> Observable<Void> {
    return
      Observable<Int>
      .timer(dueTime, period: period, scheduler: scheduler)
      .mapToVoid()
  }
}
