// Copyright © 2023 Mobecan. All rights reserved.

import Foundation
import NonEmpty
import SwiftDateTime


public protocol ComposableError: Error {

  static func composed(from children: NonEmpty<[String: Self]>) -> Self
}


extension DateTime {

  static func tryInit<SomeError: ComposableError>(
    date: Result<DayMonthYear, SomeError>,
    time: Result<HoursMinutesSeconds, SomeError>,
    timeZoneOffset: Result<Duration, SomeError>
  ) -> Result<DateTime, SomeError> {

    var errors: [String: SomeError] = [:]

    date.asError.map { errors["date"] = $0 }
    time.asError.map { errors["time"] = $0 }
    timeZoneOffset.asError.map { errors["timeZoneOffset"] = $0 }

    if let nonEmptyErrors = NonEmpty(rawValue: errors) {
      return .failure(.composed(from: nonEmptyErrors))
    }

    // swiftlint:disable:next force_try
    return try! .success(
      DateTime(
        date: date.get(),
        time: time.get(),
        timeZoneOffset: timeZoneOffset.get()
      )
    )
  }
}
