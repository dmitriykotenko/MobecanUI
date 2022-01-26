// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime
import UIKit


public extension Reactive where Base: UIDatePicker {

  var dateTime: ControlProperty<DateTime> {
    ControlProperty(
      values: date
        .map { [weak base] _ in base?.dateTime }
        .filterNil(),
      valueSink: AnyObserver<DateTime>
        .onNext { [weak base] in base?.dateTime = $0 }
    )
  }

  var dayMonthYear: ControlProperty<DayMonthYear> {
    ControlProperty(
      values: date
        .map { [weak base] _ in base?.dayMonthYear }
        .filterNil(),
      valueSink: AnyObserver<DayMonthYear>
        .onNext { [weak base] in base?.dayMonthYear = $0 }
    )
  }
}
