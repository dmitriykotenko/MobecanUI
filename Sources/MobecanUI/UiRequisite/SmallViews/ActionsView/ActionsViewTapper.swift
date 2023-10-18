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

    // У ``UITapGestureRecognizer`` никогда не происходит события `.began`.
    // Поэтому, чтобы реагировать на начало нажатия, используем ``UILongPressGestureRecognizer``.
    let longPress = containerView.rx.longPressGesture { gesture, delegate in
      gesture.minimumPressDuration = .leastNonzeroMagnitude
      delegate.beginPolicy = stateContainer.asGestureBeginPolicy()
    }

    return .init(
      containerView: containerView,
      value: valueSetter.asObserver(),
      state: .onNext { [stateContainer] in
        stateContainer.areTapsEnabled = $0.areGlobalTapsEnabled
      },
      events:
        longPress.scan(LongPressFilter(allowableDistance: 10)) { container, gesture in
          container.update(with: gesture)
        }
        .do(onNext: { [weak contentView, weak containerView, onTouchDown, onTouchUp] in
          let views = ContentAndContainerViews(
            contentView: contentView,
            containerView: containerView
          )

          switch $0.filteredState {
          case .began:
            views.map(onTouchDown)
          case .changed where !$0.isFailed:
            break
          default:
            views.map(onTouchUp)
          }
        })
        .filter {
          $0.filteredState == .recognized
          && ($0.gesture?.isHappeningInsideView == true)
        }
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
