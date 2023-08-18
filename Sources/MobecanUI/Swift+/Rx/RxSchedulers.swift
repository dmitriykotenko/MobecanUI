// Copyright © 2023 Mobecan. All rights reserved.

import Foundation
import RxSwift
import SwiftDateTime


/// Кастомные шедулеры для RxSwift.
public enum RxSchedulers {

  /// Дефолтный шедулер для тротлинга, делэев и других операторов, связанных с временем.
  /// Использует ``SerialDispatchQueueScheduler`` на основе ``DispatchQueue.global(qos: .default)``.
  public static let `default`: SchedulerType = defaultAsyncInstance

  /// Асинхронный шедулер с приоритетом ``DispatchQoS.default``.
  /// Обычно используется для того, чтобы избежать reentrancy-циклов.
  public static let defaultAsyncInstance: SerialDispatchQueueScheduler = async(qos: .default)

  /// Встроенный асинхронный шедулер с указанным приоритетом.
  /// Обычно используется для того, чтобы избежать reentrancy-циклов.
  public static func asyncInstance(qos: DispatchQoS) -> SerialDispatchQueueScheduler {
    cachedSchedulers.get(
      key: qos,
      orElse: async(qos: qos)
    )
  }

  /// Создаёт новый асинхронный шедулер с указанным приоритетом.
  /// Обычно используется для того, чтобы избежать reentrancy-циклов.
  public static func async(qos: DispatchQoS) -> SerialDispatchQueueScheduler {
    SerialDispatchQueueScheduler(qos: qos)
  }

  private static var cachedSchedulers: [(DispatchQoS, SerialDispatchQueueScheduler)] = []
}


private extension Array {

  mutating func get<Key: Equatable, Value>(key: Key,
                                           orElse initValue: @autoclosure () -> Value) -> Value
  where Element == (Key, Value) {

    if let existingValue = first(where: { $0.0 == key })?.1 {
      return existingValue
    } else {
      let newValue = initValue()
      append((key, newValue))
      return newValue
    }
  }
}
