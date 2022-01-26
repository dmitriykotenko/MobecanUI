// Copyright © 2020 Mobecan. All rights reserved.

import SwiftDateTime
import UIKit


public extension UIDatePicker {
  
  var dateTime: DateTime {
    get {
      DateTime(
        moment: date,
        timeZone: timeZone ?? calendar.timeZone
      )
    }

    set {
      date = newValue.moment
    }
  }
  
  var dayMonthYear: DayMonthYear {
    get { dateTime.date }
    
    set {
      dateTime = .from(
        date: newValue,
        time: .midnight,
        timeZone: timeZone ?? calendar.timeZone
      )
    }
  }
  
  var timeOfDay: HoursMinutesSeconds {
    get { dateTime.time }
    
    set {
      dateTime = .from(
        date: DayMonthYear(day: 1, month: 1, year: 2001),
        time: newValue,
        timeZone: timeZone ?? calendar.timeZone
      )
    }
  }
}


private extension DateTime {
  
  static func from(date: DayMonthYear,
                   time: HoursMinutesSeconds,
                   timeZone: TimeZone) -> DateTime {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = timeZone
    
    let components = DateComponents(
      timeZone: timeZone,
      year: date.year,
      month: date.month,
      day: date.day,
      hour: time.hours,
      minute: time.minutes,
      second: time.seconds,
      nanosecond: time.milliseconds * 1_000_000
    )
    
    guard
      let moment = calendar.date(from: components)
      else { fatalError("Can not build Date from DateComponents \(components)") }
    
    return DateTime(
      moment: moment,
      timeZone: timeZone
    )
  }
}
