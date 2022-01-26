// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension ObservableType {
  
  func throttle(_ dueTime: Duration,
                latest: Bool = true,
                scheduler: SchedulerType) -> Observable<Element> {

    throttle(dueTime.toDispatchTimeInterval, latest: latest, scheduler: scheduler)
  }
}


public extension SharedSequenceConvertibleType {
  
  func throttle(_ dueTime: Duration) -> SharedSequence<SharingStrategy, Element> {
    throttle(dueTime.toRxTimeInterval)
  }
}
