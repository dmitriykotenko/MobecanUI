//  Copyright © 2020 Mobecan. All rights reserved.

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

  init(possibleButtonsAndActions: [SideAction: UIButton],
       animationDuration: Duration) {
    self.possibleButtonsAndActions = possibleButtonsAndActions
    
    self.buttonWidths = possibleButtonsAndActions.mapValues {
      $0.layoutIfNeeded()
      return $0.frame.width
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


private class SwipableView: UIView {

  @RxUiInput(0) var trailingViewWidth: AnyObserver<CGFloat>
  
  private var mainSubviewTrailing: Constraint?
  private var bouncer: Bouncer?
  
  private let disposeBag = DisposeBag()
  
  required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  init(contentView: UIView,
       trailingView: UIView,
       trailingViewWidth: CGFloat,
       animationDuration: Duration) {
    super.init(frame: .zero)
    
    let mainSubview = TranslationView(.hstack([contentView, trailingView]))

    addSubview(mainSubview)
    
    mainSubview.snp.makeConstraints {
      $0.top.bottom.leading.equalToSuperview()
      mainSubviewTrailing = $0.trailing.equalToSuperview().inset(trailingViewWidth).constraint
    }
    
    contentView.snp.makeConstraints {
      $0.width.equalTo(self)
    }

    let bouncer = HorizontalBouncer(
      panContainer: self,
      pan: rx.exclusiveHorizontalPan(),
      animationDuration: animationDuration,
      attractors: [0, trailingViewWidth]
    )

    Observable
      .combineLatest(bouncer.offset, _trailingViewWidth) { offset, trailingWidth in
        CGPoint(x: offset - trailingWidth, y: 0)
      }
      .bind(to: mainSubview.translation)
      .disposed(by: disposeBag)
    
    self.bouncer = bouncer
    
    [
      _trailingViewWidth.map { $0 == 0 ? [0] : [0, $0] }.bind(to: bouncer.attractors),
      _trailingViewWidth.bind(to: bouncer.attractor)
    ]
    .disposed(by: disposeBag)

    mainSubviewTrailing.map {
      _trailingViewWidth.map { -$0 }.bind(to: $0.rx.inset).disposed(by: disposeBag)
    }
    
    self.trailingViewWidth.onNext(trailingViewWidth)
  }
}
