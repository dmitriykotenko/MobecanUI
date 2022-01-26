// Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import SnapKit
import SwiftDateTime
import UIKit


open class ActionsViewSwiper<ContentView: DataView & EventfulView>: ActionsViewIngredientMixer {
  
  public typealias SideAction = ActionsViewStructs.SideAction
  
  public typealias State = [SideAction]
  public typealias Event = (SideAction, ContentView.Value)
  
  private let possibleButtonsAndActions: [SideAction: UIButton]
  private let buttonWidths: [SideAction: CGFloat]
  private let buttons: [UIButton]
  
  private let animationDuration: Duration

  public init(possibleButtonsAndActions: [SideAction: UIButton],
              animationDuration: Duration) {
    self.possibleButtonsAndActions = possibleButtonsAndActions
    
    self.buttonWidths = possibleButtonsAndActions.mapValues {
      $0.sizeThatFits(
        .init(
          width: CGFloat.greatestFiniteMagnitude,
          height: CGFloat.greatestFiniteMagnitude
        )
      )
      .width
    }
    
    self.buttons = Array(possibleButtonsAndActions.values)
    
    self.animationDuration = animationDuration
  }

  open func setup(contentView: ContentView,
                  containerView: UIView) -> ActionsViewStructs.Ingredient<ContentView.Value, State, Event> {
    let newContainerView = SwipableView(
      contentView: containerView,
      trailingView: .hstack(buttons),
      trailingViewWidth: buttonWidths.values.reduce(0, +),
      animationDuration: animationDuration
    )
    
    let valueSetter = BehaviorSubject<Value?>(value: nil)
    
    let events = Observable.merge(
        possibleButtonsAndActions.map { action, button in button.rx.tap.map { action } }
      )
      .withLatestFrom(valueSetter.filterNil()) { ($0, $1) }
    
    return .init(
      containerView: newContainerView,
      value: valueSetter.asObserver(),
      state: .onNext { [possibleButtonsAndActions, buttonWidths] actions in
        let buttonsWidth = buttonWidths
          .filterKeys { actions.contains($0) }
          .values
          .reduce(0, +)
        
        newContainerView.trailingViewWidth.onNext(buttonsWidth)

        possibleButtonsAndActions.forEach { action, button in
          button.isVisible = actions.contains(action)
        }
      },
      events: events
    )
  }
}


private class SwipableView: LayoutableView {

  @RxUiInput(0) var trailingViewWidth: AnyObserver<CGFloat>
  
  private var bouncer: Bouncer?
  
  private let disposeBag = DisposeBag()
  
  required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  init(contentView: UIView,
       trailingView: UIView,
       trailingViewWidth: CGFloat,
       animationDuration: Duration) {
    super.init()
    
    let mainSubview = TranslationView(
      .hstack([
        contentView,
        .stretchableHorizontalSpacer(),
        trailingView
      ])
    )

    self.layout = mainSubview.asLayout.withInsets(.right(-trailingViewWidth))

    let bouncer = HorizontalBouncer(
      panContainer: self,
      pan: rx.exclusiveHorizontalPan(),
      animationDuration: animationDuration,
      attractors: [0, trailingViewWidth]
    )

    disposeBag {
      mainSubview.translation <==
        .combineLatest(bouncer.offset, _trailingViewWidth) { offset, trailingWidth in
          CGPoint(x: offset - trailingWidth, y: 0)
        }
    }

    self.bouncer = bouncer
    
    disposeBag {
      _trailingViewWidth.map { $0 == 0 ? [0] : [0, $0] } ==> bouncer.attractors
      _trailingViewWidth ==> bouncer.attractor
    }

    disposeBag {
      _trailingViewWidth ==> { [weak self] in
        self?.layout = mainSubview.asLayout.withInsets(.right(-$0))
      }
    }

    self.trailingViewWidth.onNext(trailingViewWidth)
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    super.sizeThatFits(size)
  }
}
