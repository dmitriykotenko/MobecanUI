// Copyright © 2023 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import UIKit


open class ActionsViewTapper<ContentView: DataView & EventfulView>: ActionsViewIngredientMixer {

  public struct ContentAndContainerViews {
    public var contentView: ContentView
    public var containerView: UIView

    init?(contentView: ContentView?, containerView: UIView?) {
      guard let contentView, let containerView else { return nil }

      self.contentView = contentView
      self.containerView = containerView
    }
  }
  
  public typealias State = ActionsViewStructs.GlobalTapsState
  
  public typealias Event = Tap<ContentView.Value>

  private let onTouchDown: (ContentAndContainerViews) -> Void
  private let onTouchUp: (ContentAndContainerViews) -> Void

  public init(onTouchDown: @escaping (ContentAndContainerViews) -> Void,
              onTouchUp: @escaping (ContentAndContainerViews) -> Void) {
    self.onTouchDown = onTouchDown
    self.onTouchUp = onTouchUp
  }
  
  open func setup(contentView: ContentView,
                  containerView: UIView) -> ActionsViewStructs.Ingredient<ContentView.Value, State, Event> {
    let valueSetter = BehaviorSubject<Value?>(value: nil)

    let stateContainer = StateContainer(areTapsEnabled: true)

    let tap = containerView.rx.tapGesture { _, delegate in
      delegate.beginPolicy = stateContainer.asGestureBeginPolicy()
    }

    // У ``UITapGestureRecognizer`` никогда не происходит события `.began`.
    // Поэтому, чтобы реагировать на начало нажатия, нужен дополнительный распознаватель жестов,
    // у которого есть такое событие.
    let longPress = containerView.rx.longPressGesture { _, delegate in
      delegate.beginPolicy = stateContainer.asGestureBeginPolicy()
    }

    return .init(
      containerView: containerView,
      value: valueSetter.asObserver(),
      state: .onNext { [stateContainer] in
        stateContainer.areTapsEnabled = $0.areGlobalTapsEnabled
      },
      events: Observable.merge(
        longPress.map(\.state)
          .filter { $0 == .began }
          .do(onNext: { [weak contentView, weak containerView, onTouchDown] _ in
            ContentAndContainerViews(
              contentView: contentView,
              containerView: containerView
            )
            .map(onTouchDown)
          }),
        tap.map(\.state)
          .filter { $0 == .recognized }
          .do(onNext: { [weak contentView, weak containerView, onTouchUp] _ in
            ContentAndContainerViews(
              contentView: contentView,
              containerView: containerView
            )
            .map(onTouchUp)
          })
      )
      .filter { $0 == .recognized }
      .withLatestFrom(valueSetter.filterNil())
      .map { Tap($0) }
      .share()
    )
  }
}


private class StateContainer {

  var areTapsEnabled: Bool

  func asGestureBeginPolicy<Gesture: UIGestureRecognizer>() -> GestureRecognizerDelegatePolicy<Gesture> {
    .custom { _ in self.areTapsEnabled }
  }

  init(areTapsEnabled: Bool) {
    self.areTapsEnabled = areTapsEnabled
  }
}
