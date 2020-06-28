//  Copyright © 2020 Mobecan. All rights reserved.


import RxSwift
import RxCocoa
import SnapKit
import UIKit


open class RadioButton<Element: Equatable>: UIView {

  public enum SelectionStrategy {
    /// At most one element can be selected. When you tap on selected element, it becomes unselected.
    case singleElementOrNil
    /// Some element is always selected. Taps on currently selected element have no effect.
    case singleElement
  }

  // MARK: - Inputs and outputs
  @RxUiInput([]) public var visibleElements: AnyObserver<[Element]>
  @RxUiInput public var selectElement: AnyObserver<Element?>
  @RxDriverOutput(nil) public var selectedElement: Driver<Element?>
  @RxSignalOutput public var userDidSelectElement: Signal<Element?>

  // MARK: - Subviews
  private let horizontalStack = UIStackView(arrangedSubviews: [])
  
  private let createButton: (Element) -> UIButton
  private let selectionStrategy: SelectionStrategy
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initialization
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(visibleElements: [Element],
              createButton: @escaping (Element) -> UIButton,
              selectionStrategy: SelectionStrategy = .singleElement,
              distribution: UIStackView.Distribution = .fillEqually,
              insets: UIEdgeInsets = .zero,
              spacing: CGFloat = 0) {
    
    self.createButton = createButton
    self.selectionStrategy = selectionStrategy

    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    
    setupHorizontalStack(distribution: distribution, spacing: spacing, insets: insets)
    setupVisibleElements(createButton: createButton)

    setupProgrammaticSelection()
    setupInitialState(visibleElements: visibleElements)
  }
  
  private func setupVisibleElements(createButton: @escaping (Element) -> UIButton) {
    _visibleElements
      .subscribe(onNext: { [weak self] in self?.recreateButtons(visibleElements: $0) })
      .disposed(by: disposeBag)
    
    _visibleElements
      .withLatestFrom(selectedElement) { [selectionStrategy] visible, selected -> Element? in
        switch selectionStrategy {
        case .singleElement:
          return visible.contains { $0 == selected } ? selected : visible.first
        case .singleElementOrNil:
          return visible.contains { $0 == selected } ? selected : nil
        }
      }
    .bind(to: _selectedElement)
    .disposed(by: disposeBag)
  }
  
  private func setupHorizontalStack(distribution: UIStackView.Distribution,
                                    spacing: CGFloat,
                                    insets: UIEdgeInsets) {
    horizontalStack.axis = .horizontal
    horizontalStack.distribution = distribution
    horizontalStack.spacing = spacing
    
    // TODO: Investigate why .isLayoutMarginsRelativeArrangement breaks the layout
    horizontalStack.isLayoutMarginsRelativeArrangement = false

    putSubview(horizontalStack, insets: insets)
  }
    

  private func recreateButtons(visibleElements: [Element]) {
    let buttons = visibleElements.map { createButton($0) }
    
    horizontalStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    buttons.forEach { horizontalStack.addArrangedSubview($0) }
    
    zip(buttons, visibleElements)
      .forEach { button, element in bindButton(button, to: element) }
  }
  
  private func bindButton(_ button: UIButton,
                          to element: Element) {
    let tappedElement = button.rx.tap.map { _ -> Element in element }
    
    let elementToSelect = tappedElement
      .withLatestFrom(selectedElement) { [selectionStrategy] tapped, selected -> Element? in
        switch selectionStrategy {
        case .singleElement:
          return tapped
        case .singleElementOrNil:
          return tapped == selected ? nil : tapped
        }
      }
    
    [
      selectedElement.asObservable().map { $0 == element }.bind(to: button.rx.isSelected),
      elementToSelect.bind(to: _userDidSelectElement)
    ]
    .disposed(by: disposeBag)
  }

  private func setupProgrammaticSelection() {
    let programmaticallySelectedElement = _selectElement
      .withLatestFrom(_visibleElements) { (new: $0, visible: $1) }
      .filter { [selectionStrategy] in
        switch $0.new {
        case nil:
          return selectionStrategy == .singleElementOrNil
        case let element?:
          // Do not allow to select elements that are not displayed by RadioButton
          return $0.visible.contains(element)
        }
      }
      .map { $0.new }
    
    programmaticallySelectedElement
      .bind(to: _selectedElement)
      .disposed(by: disposeBag)
  }
  
  private func setupInitialState(visibleElements: [Element]) {
      self.visibleElements.onNext(visibleElements)
  }
}