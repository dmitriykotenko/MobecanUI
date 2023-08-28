// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension ObservableType where Element: RxAbstractInteger {
  
  static func timer(_ dueTime: Duration,
                    period: Duration? = nil,
                    scheduler: SchedulerType) -> Observable<Element> {
    timer(
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
    Observable<Int>
      .timer(dueTime, period: period, scheduler: scheduler)
      .mapToVoid()
  }
}


public extension PrimitiveSequenceType where Trait == SingleTrait, Element: RxAbstractInteger {

  static func timer(_ dueTime: Duration,
                    scheduler: SchedulerType) -> Single<Element> {
    timer(
      dueTime.toRxTimeInterval,
      scheduler: scheduler
    )
  }
}


public extension PrimitiveSequenceType where Trait == SingleTrait, Element == Void {

  static func voidTimer(_ dueTime: Duration,
                        scheduler: SchedulerType) -> Single<Void> {
    Single<Int>
      .timer(dueTime, scheduler: scheduler)
      .mapToVoid()
  }
}
