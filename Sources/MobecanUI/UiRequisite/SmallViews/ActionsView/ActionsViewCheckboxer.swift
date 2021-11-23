//  Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit


open class ActionsViewCheckboxer<ContentView: DataView & EventfulView>: ActionsViewIngredientMixer {
  
  public typealias State = ActionsViewStructs.SelectionState
  
  public enum Event {
    case select(ContentView.Value)
    case deselect(ContentView.Value)
  }

  private let initCheckmarkView: () -> CheckmarkView
  private let checkmarkPlacement: ActionsViewStructs.CheckmarkPlacement
  
  public init(initCheckmarkView: @escaping () -> CheckmarkView,
              checkmarkPlacement: ActionsViewStructs.CheckmarkPlacement) {
    self.initCheckmarkView = initCheckmarkView
    self.checkmarkPlacement = checkmarkPlacement
  }
  
  open func setup(contentView: ContentView,
                  containerView: UIView) -> ActionsViewStructs.Ingredient<ContentView.Value, State, Event> {
    let checkmarkView = initCheckmarkView()
    
    let newContainerView = container(
      contentView: contentView,
      containerView: containerView,
      checkmarkView: checkmarkView
    )
    
    let valueSetter = BehaviorSubject<Value?>(value: nil)
    
    let areTapsEnabled = BehaviorSubject<Bool>(value: false)
    
    let events: Observable<Event> =
      newContainerView.rx.tapGesture().when(.recognized)
        .withLatestFrom(checkmarkView.isSelected)
        .withLatestFrom(valueSetter.filterNil()) { $0 ? .deselect($1) : .select($1) }
        .filterWith(areTapsEnabled)
        .share()
    
    return .init(
      containerView: newContainerView,
      value: valueSetter.asObserver(),
      state: .onNext {
        switch $0 {
        case .notSelectable:
          checkmarkView.isVisible = false
          areTapsEnabled.onNext(false)
        case .isSelected(let isSelected):
          checkmarkView.isVisible = true
          checkmarkView.setIsSelected.onNext(isSelected)
          areTapsEnabled.onNext(true)
        }
      },
      events: events
    )
  }
  
  private func container(contentView: ContentView,
                         containerView: UIView,
                         checkmarkView: CheckmarkView) -> UIView {
    LayoutableView(
      layout: StackLayout(
        axis: .horizontal,
        sublayouts: orderHorizontally(
          containerViewLayout:
            containerView.asLayout,
          checkmarkViewLayout:
            checkmarkView.withAlignment(verticalCheckmarkAlignment(contentView: contentView))
        )
      )
    )
  }

  private func orderHorizontally(containerViewLayout: Layout,
                                 checkmarkViewLayout: Layout) -> [Layout] {
    let stretchableSpacer = UIView.stretchableHorizontalSpacer().asLayout

    switch checkmarkPlacement.horizontal {
    case .leading:
      return [checkmarkViewLayout, containerViewLayout, stretchableSpacer]
    case .trailing:
      return [containerViewLayout, stretchableSpacer, checkmarkViewLayout]
    }
  }

  private func verticalCheckmarkAlignment(contentView: UIView) -> Alignment {
    switch checkmarkPlacement.vertical {
    case .center:
      return .centerY(contentView)
    case .top(let offset):
      return .top(offset: offset)
    }
  }
}


private extension Alignment {

  static func top(offset: CGFloat) -> Alignment {
    .init { size, frame in
      CGRect(
        x: frame.minX,
        y: frame.minY + offset,
        width: frame.width,
        height: size.height
      )
    }
  }

  static func centerY(_ view: UIView) -> Alignment {
    .init { [weak view] size, frame in
      let viewHeight = view?.frame.height ?? 0

      return CGRect(
        origin: .init(
          x: frame.origin.x,
          y: frame.origin.y + 0.5 * (viewHeight - size.height)
        ),
        size: size
      )
    }
  }
}
