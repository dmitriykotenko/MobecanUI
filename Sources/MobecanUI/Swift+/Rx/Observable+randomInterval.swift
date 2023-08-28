// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension Observable where Element == Void {

  /// Аналог ``ObservableType.timer(_:period:scheduler:)``.
  /// Возвращает ``Observable``, который периодически испускает следущее значение. Задержка между значениями случайна.
  /// Первое значение испускается немедленно.
  /// - Parameters:
  ///   - average: Средняя задержка перед каждым следующим значением.
  ///   - scheduler: Шедулер, который будет обрабатывать задержки между значениями.
  /// - Warning: Текущая реализация в конце концов приводит к переполнению стэка.
  /// Обычно это проявляется при маленьком ``average`` (порядка нескольких миллисекунд)
  /// или при долгой работе приложения.
  static func randomInterval(average: Duration,
                             scheduler: SchedulerType = RxSchedulers.default) -> Observable<Void> {
    randomInterval(
      average: average,
      deviation: average * 0.5,
      scheduler: scheduler
    )
  }

  /// Аналог ``Observable.timer(_:period:scheduler:)``.
  /// Возвращает ``Observable``, который периодически испускает следущее значение. Задержка между значениями случайна.
  /// Первое значение испускается немедленно.
  /// - Parameters:
  ///   - average: Средняя задержка перед каждым следующим значением.
  ///   - deviation: Максимальное отклонение от средней задержки.
  ///   - scheduler: Шедулер, который будет обрабатывать задержки между значениями.
  /// - Warning: Текущая реализация в конце концов приводит к переполнению стэка.
  /// Обычно это проявляется при маленьком ``average`` (порядка нескольких миллисекунд)
  /// или при долгой работе приложения.
  static func randomInterval(average: Duration,
                             deviation: Duration,
                             scheduler: SchedulerType = RxSchedulers.default) -> Observable<Void> {
    let possibleIntervals = (average - deviation)...(average + deviation)

    return Observable<Int>.timer(.random(in: possibleIntervals), scheduler: scheduler)
      .mapToVoid()
      // TODO: придумать альтернативу flatMapLatest, чтобы избавиться от переполнения стэка
      .flatMapLatest {
        randomInterval(
          average: average,
          deviation: deviation
        ).startWith(())
      }
  }
}
