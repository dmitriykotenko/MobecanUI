//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension Observable where Element == Void {
  
  static func randomInterval(average: Duration,
                             scheduler: SchedulerType = MainScheduler.instance) -> Observable<Void> {
    return randomInterval(
      average: average,
      deviation: average * 0.5,
      scheduler: scheduler
    )
  }

  static func randomInterval(average: Duration,
                             deviation: Duration,
                             scheduler: SchedulerType = MainScheduler.instance) -> Observable<Void> {
    let possibleIntervals = (average - deviation)...(average + deviation)
    
    return Observable<Int>.timer(.random(in: possibleIntervals), scheduler: scheduler)
      .mapToVoid()
      .flatMapLatest {
        randomInterval(
          average: average,
          deviation: deviation
        ).startWith(())
      }
  }
}
