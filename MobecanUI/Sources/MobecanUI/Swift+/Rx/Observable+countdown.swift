//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension Observable where Element == Duration {
  
  static func countdown(deadline: DateTime,
                        interval: Duration = 1.seconds,
                        clock: Clock,
                        scheduler: SchedulerType = MainScheduler.instance) -> Observable<Duration> {
    let firstPulseDelay = (deadline - clock.now).positiveRemainder(divider: interval)
    
    return Observable<Void>
      .voidInterval(interval, scheduler: scheduler)
      .delay(firstPulseDelay, scheduler: scheduler)
      .startWith(())
      .map { (deadline - clock.now).rounded(to: interval) }
      .map { $0.clipped(inside: (.zero)...(.max)) }
      .takeWhile { $0 >= .zero }
  }
}
