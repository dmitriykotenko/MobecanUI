//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension ObservableType {
  
  func delay(_ dueTime: Duration,
             scheduler: SchedulerType) -> Observable<Element> {
    delay(dueTime.toRxTimeInterval, scheduler: scheduler)
  }
}


public extension PrimitiveSequence {
  
  func delay(_ dueTime: Duration,
             scheduler: SchedulerType) -> PrimitiveSequence<Trait, Element> {
    delay(dueTime.toRxTimeInterval, scheduler: scheduler)
  }
}


public extension SharedSequenceConvertibleType {
  
  func delay(_ dueTime: Duration) -> SharedSequence<SharingStrategy, Element> {
    delay(dueTime.toRxTimeInterval)
  }
}
