// Copyright © 2023 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import SwiftDateTime
import UIKit


/// Дополнительный фильтр для ``UILongPressGestureRecognizer``.
open class LongPressFilter {

  /// Максимально разрешённое расстояние между начальными и промежуточными координатами жеста.
  ///
  /// Если координаты жеста хотя бы один раз отклонились от начальной точки больше,
  /// чем на это расстояние, жест считается неуспешным.
  ///
  /// - Warning: Не путайте с `UILongPressGestureRecognizer.allowableMovement`.
  /// `UILongPressGestureRecognizer.allowableMovement` используется в самом начале жеста,
  /// ещё до того, как жест перейдёт в состояние `.began`.
  public let allowableDistance: CGFloat

  open private(set) var gesture: UILongPressGestureRecognizer?

  private var startLocation: CGPoint?
  private var currentLocation: CGPoint?

  open private(set) var isFailed: Bool = false

  /// Состояние жеста с учётом дополнительных проверок.
  open var filteredState: UIGestureRecognizer.State? {
    switch gesture?.state {
    case nil:
      return nil
    case _? where isFailed:
      return .failed
    case let state?:
      return state
    }
  }

  /// - Parameter allowableDistance: Максимально разрешённое расстояние
  /// между начальными и промежуточными координатами жеста.
  /// Если координаты жеста хотя бы один раз отклонились от начальной точки больше,
  /// чем на это расстояние, жест считается неуспешным.
  ///
  /// - Warning: Не путайте `allowableDistance` и `UILongPressGestureRecognizer.allowableMovement`.
  /// `UILongPressGestureRecognizer.allowableMovement` используется в самом начале жеста,
  /// ещё до того, как жест перейдёт в состояние `.began`.
  public init(allowableDistance: CGFloat) {
    self.allowableDistance = allowableDistance
  }

  /// Обновляет состояние фильтра.
  open func update(with gesture: UILongPressGestureRecognizer) -> Self {
    self.gesture = gesture

    switch gesture.state {
    case .possible:
      startLocation = nil
      currentLocation = nil
      isFailed = false
    case .began:
      startLocation = gesture.location(in: gesture.view?.window)
      currentLocation = nil
      isFailed = false
    default:
      currentLocation = gesture.location(in: gesture.view?.window)
      isFailed =
        zip(currentLocation, startLocation)
          .map { $0.distance(to: $1) > allowableDistance }
          ?? false
    }

    return self
  }
}
