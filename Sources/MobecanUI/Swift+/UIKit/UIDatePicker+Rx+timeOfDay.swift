//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime
import UIKit


public extension Reactive where Base: UIDatePicker {

  var timeOfDay: ControlProperty<HoursMinutesSeconds> {
    ControlProperty(
      values: date
        .map { [weak base] _ in base?.timeOfDay }
        .filterNil(),
      valueSink: AnyObserver<HoursMinutesSeconds>
        .onNext { [weak base] in base?.timeOfDay = $0 }
    )
  }
}
