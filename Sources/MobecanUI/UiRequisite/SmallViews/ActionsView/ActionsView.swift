//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


public class ActionsView<ContentView: DataView & EventfulView>: UIView, DataView, EventfulView {

  public typealias Structs = ActionsViewStructs
  
  public typealias CheckmarkPlacement = Structs.CheckmarkPlacement
  public typealias SelectionState = Structs.SelectionState
  public typealias SideAction = Structs.SideAction
  public typealias IngredientsState = Structs.IngredientsState
  
  public typealias Value = ContentView.Value

  public enum ViewEvent {
    case select(Value)
    case deselect(Value)
    case delete(Value)
    
    case nestedEvent(ContentView.ViewEvent)
  }

  @RxUiInput(nil) public var value: AnyObserver<Value?>
  @RxUiInput(nil) public var ingredientsState: AnyObserver<IngredientsState?>
  
  @RxOutput public var viewEvents: Observable<ViewEvent>

  public var nestedViewEvents: Observable<ContentView.ViewEvent> {
    return contentView.viewEvents
  }

  private let contentView: ContentView
  private let contentViewPadding: UIEdgeInsets

  private let errorDisplayer: ActionsViewErrorDisplayer<ContentView>
  private let checkboxer: ActionsViewCheckboxer<ContentView>
  private let swiper: ActionsViewSwiper<ContentView>
  
  private let disposeBag = DisposeBag()

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(contentView: ContentView,
              padding: UIEdgeInsets = .zero,
              errorDisplayer: ActionsViewErrorDisplayer<ContentView>,
              checkboxer: ActionsViewCheckboxer<ContentView>,
              swiper: ActionsViewSwiper<ContentView>) {
    self.contentView = contentView
    self.contentViewPadding = padding
    
    self.errorDisplayer = errorDisplayer
    self.checkboxer = checkboxer
    self.swiper = swiper
    
    super.init(frame: .zero)
    
    addSubviews()
  }
  
  private func addSubviews() {
    let checkboxIngredient = checkboxer.setup(
      contentView: contentView,
      containerView: .zstack(padding: contentViewPadding, [contentView])
    )
    
    let errorIngredient = errorDisplayer.setup(
      contentView: contentView,
      containerView: checkboxIngredient.containerView
    )
    
    let swiperIngredient = swiper.setup(
      contentView: contentView,
      containerView: errorIngredient.containerView
    )
    
    addSingleSubview(swiperIngredient.containerView)
    
    Observable
      .merge(
        checkboxIngredient.events.map {
          switch $0 {
          case .select(let value):
            return .select(value)
          case .deselect(let value):
            return .deselect(value)
          }
        },
        swiperIngredient.events.map {
          let (event, value) = $0
          switch event {
          case .delete:
            return .delete(value)
          }
        }
      )
      .bind(to: _viewEvents)
      .disposed(by: disposeBag)
    
    displayEverything(
      valueObservers: [contentView.value, checkboxIngredient.value, errorIngredient.value, swiperIngredient.value],
      selectionState: checkboxIngredient.state,
      errorText: errorIngredient.state,
      sideActions: swiperIngredient.state
    )
  }
  
  private func displayEverything(valueObservers: [AnyObserver<Value?>],
                                 selectionState: AnyObserver<SelectionState>,
                                 errorText: AnyObserver<String?>,
                                 sideActions: AnyObserver<[SideAction]>) {
    valueObservers
      .map { _value.bind(to: $0) }
      .disposed(by: disposeBag)

    [
      _ingredientsState.compactMap { $0?.selectionState }.bind(to: selectionState),
      _ingredientsState.map { $0?.errorText }.bind(to: errorText),
      _ingredientsState.compactMap { $0?.sideActions }.bind(to: sideActions)
    ]
    .disposed(by: disposeBag)
  }
}
