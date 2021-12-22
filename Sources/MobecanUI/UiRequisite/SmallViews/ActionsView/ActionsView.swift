//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


public class ActionsView<
  ContentView: DataView & EventfulView,
  SideAction: Hashable
>: UIView, DataView, EventfulView {

  public typealias Structs = ActionsViewStructs
  
  public typealias Insets = Structs.Insets
  public typealias CheckmarkPlacement = Structs.CheckmarkPlacement
  public typealias SelectionState = Structs.SelectionState
  public typealias IngredientsState = Structs.IngredientsState<SideAction>
  
  public typealias Value = ContentView.Value

  public enum ViewEvent {
    case select(Value)
    case deselect(Value)
    case sideAction(SideAction, value: Value)
    
    case nestedEvent(ContentView.ViewEvent)
  }

  @RxUiInput(nil) public var value: AnyObserver<Value?>
  @RxUiInput(nil) public var ingredientsState: AnyObserver<IngredientsState?>
  
  @RxOutput public var viewEvents: Observable<ViewEvent>

  public var nestedViewEvents: Observable<ContentView.ViewEvent> {
    contentView.viewEvents
  }

  private let contentView: ContentView
  private let insets: Insets

  private let errorDisplayer: ActionsViewErrorDisplayer<ContentView>
  private let checkboxer: ActionsViewCheckboxer<ContentView>
  private let swiper: ActionsViewSwiper<ContentView, SideAction>
  
  private let disposeBag = DisposeBag()

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(contentView: ContentView,
              insets: Insets = .init(overall: .zero, contentView: .zero),
              errorDisplayer: ActionsViewErrorDisplayer<ContentView> = .defaultErrorDisplayer(),
              checkboxer: ActionsViewCheckboxer<ContentView> = .defaultCheckboxer(),
              swiper: ActionsViewSwiper<ContentView, SideAction> = .defaultSwiper()) {
    self.contentView = contentView
    self.insets = insets
    
    self.errorDisplayer = errorDisplayer
    self.checkboxer = checkboxer
    self.swiper = swiper
    
    super.init(frame: .zero)
    
    addSubviews()
  }
  
  private func addSubviews() {
    let checkboxIngredient = checkboxer.setup(
      contentView: contentView,
      containerView: .zstack([contentView], insets: insets.contentView)
    )
    
    let errorIngredient = errorDisplayer.setup(
      contentView: contentView,
      containerView: checkboxIngredient.containerView
    )
    
    let swiperIngredient = swiper.setup(
      contentView: contentView,
      containerView: errorIngredient.containerView
    )
    
    putSubview(swiperIngredient.containerView, insets: insets.overall)

    disposeBag {
      _viewEvents <== .merge(
        nestedViewEvents.map { .nestedEvent($0) },
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
          return .sideAction(event, value: value)
        }
      )
    }

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

    disposeBag {
      _ingredientsState.compactMap(\.?.selectionState) ==> selectionState
      _ingredientsState.map(\.?.errorText) ==> errorText
      _ingredientsState.compactMap(\.?.sideActions) ==> sideActions
    }
  }
}
