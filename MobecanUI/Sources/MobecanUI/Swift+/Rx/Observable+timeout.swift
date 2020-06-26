//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension ObservableType {
  
  func timeout(_ dueTime: Duration,
               scheduler: SchedulerType) -> Observable<Element> {
    return timeout(
      dueTime.toRxTimeInterval,
      scheduler: scheduler
    )
  }
}
