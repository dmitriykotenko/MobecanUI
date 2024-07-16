// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import RxSwift
import SwiftDateTime


extension Duration: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Duration> {
    Int64.defaultGenerator.map { Duration(milliseconds: $0) }
  }

  public static func random(in range: Range<Duration>) -> Duration {
    .init(milliseconds: .random(in: range.mapBounds(\.milliseconds)))
  }
}


extension TimeZone: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<TimeZone> {
    .pure {
      let offset = Duration.random(in: (-12.hours)...(14.hours)).rounded(to: 1.seconds)

      return TimeZone(secondsFromGMT: Int(offset.milliseconds / 1000)) ?? .utc
    }
  }
}


extension DateTime: AutoGeneratable {

  public final class BuiltinGenerator: MobecanGenerator<DateTime> {

    public var moment: MobecanGenerator<Date>
    public var timeZone: MobecanGenerator<TimeZone>

    public init(moment: MobecanGenerator<Date> = Date.defaultGenerator,
                timeZone: MobecanGenerator<TimeZone> = TimeZone.defaultGenerator) {
      self.moment = moment
      self.timeZone = timeZone
    }

    override public func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<DateTime>> {
      Single
        .zip(factory.generate(via: moment), factory.generate(via: timeZone))
        .map { zip($0, $1) }
        .mapSuccess { DateTime(moment: $0, timeZone: $1) }
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}


extension DayMonthYear: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<DayMonthYear> {
    DateTime.defaultGenerator.map(\.date)
  }
}


extension HoursMinutesSeconds: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<HoursMinutesSeconds> {
    DateTime.defaultGenerator.map(\.time)
  }
}


extension MonthYear: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<MonthYear> {
    DayMonthYear.defaultGenerator.map(\.monthYear)
  }
}
