// Copyright © 2022 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension ObservableType {

  func debounce(_ dueTime: Duration,
                scheduler: SchedulerType) -> Observable<Element> {

    debounce(dueTime.toDispatchTimeInterval, scheduler: scheduler)
  }
}


public extension SharedSequenceConvertibleType {

  func debounce(_ dueTime: Duration) -> SharedSequence<SharingStrategy, Element> {
    debounce(dueTime.toRxTimeInterval)
  }
}
