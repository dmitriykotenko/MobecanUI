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

    let beginPolicy = TapsBeginPolicy(areTapsEnabled: true)

    let tap = containerView.rx.tapGesture { _, delegate in
      delegate.beginPolicy = .custom { [beginPolicy] _ in beginPolicy.shouldBeginTapGesture }
    }

    return .init(
      containerView: containerView,
      value: valueSetter.asObserver(),
      state: .onNext { [beginPolicy] in
        beginPolicy.areTapsEnabled = $0.areGlobalTapsEnabled
      },
      events: tap
        .do(onNext: { [weak contentView, weak containerView, onTouchDown, onTouchUp] in
          switch $0.state {
          case .began:
            zip(contentView, containerView)
              .map { ContentAndContainerViews(contentView: $0, containerView: $1) }
              .map(onTouchDown)
          case .ended, .cancelled, .failed:
            zip(contentView, containerView)
              .map { ContentAndContainerViews(contentView: $0, containerView: $1) }
              .map(onTouchUp)
          default:
            break
          }
        })
        .filter { $0.state == .recognized }
        .withLatestFrom(valueSetter.filterNil())
        .map { Tap($0) }
        .share()
    )
  }
}


private class TapsBeginPolicy {

  var areTapsEnabled: Bool

  var shouldBeginTapGesture: Bool { areTapsEnabled }

  init(areTapsEnabled: Bool) {
    self.areTapsEnabled = areTapsEnabled
  }
}
