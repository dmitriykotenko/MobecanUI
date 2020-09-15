//  Copyright © 2020 Mobecan. All rights reserved.

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
    let container = unalignedContainer(
      containerView: containerView,
      checkmarkView: checkmarkView
    )
    
    verticallyAlignCheckmark(
      contentView: contentView,
      checkmarkView: checkmarkView
    )
    
    return container
  }

  private func unalignedContainer(containerView: UIView,
                                  checkmarkView: CheckmarkView) -> UIView {
    switch checkmarkPlacement.horizontal {
    case .leading:
      return .hstack([ .verticallyFlexible(checkmarkView), containerView])
    case .trailing:
      return .hstack([containerView, .verticallyFlexible(checkmarkView)])
    }
  }
  
  private func verticallyAlignCheckmark(contentView: ContentView,
                                        checkmarkView: CheckmarkView) {
    switch checkmarkPlacement.vertical {
    case .center:
      checkmarkView.snp.makeConstraints { $0.centerY.equalTo(contentView) }
    case .contentViewFirstBaseline(let offset):
      checkmarkView.snp.makeConstraints {
        $0.bottom.equalTo(contentView.snp.firstBaseline).offset(offset)
      }
    }
  }
}


private extension UIView {
  
  static func verticallyFlexible(_ subview: UIView) -> UIView {
    let containerView = UIView()
    
    containerView.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
    
    return containerView
  }
}
