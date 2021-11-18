//  Copyright © 2020 Mobecan. All rights reserved.


import LayoutKit
import RxSwift
import RxCocoa
import SnapKit
import UIKit


open class RadioButton<Element: Equatable>: LayoutableView {

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
  private var horizontalStack: StackView?
  
  private let createButton: (Element) -> UIButton
  private let selectionStrategy: SelectionStrategy
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initialization
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(visibleElements: [Element],
              createButton: @escaping (Element) -> UIButton,
              selectionStrategy: SelectionStrategy = .singleElement,
              distribution: UIStackView.Distribution = .fillEqually,
              spacing: CGFloat = 0,
              insets: UIEdgeInsets = .zero) {
    
    self.createButton = createButton
    self.selectionStrategy = selectionStrategy

    super.init()

    translatesAutoresizingMaskIntoConstraints = false

    setupHorizontalStack(distribution: distribution, spacing: spacing, insets: insets)
    setupVisibleElements(createButton: createButton)

    setupProgrammaticSelection()
    setupInitialState(visibleElements: visibleElements)
  }

  private func setupHorizontalStack(distribution: UIStackView.Distribution,
                                    spacing: CGFloat,
                                    insets: UIEdgeInsets) {
    horizontalStack = .init(
      axis: .horizontal,
      spacing: spacing,
      distribution: distribution.asLayoutKitDistribution,
      contentInsets: insets,
      flexibility: .flexible
    )

    horizontalStack.map {
      layout = $0.asLayout.withInsets(insets)
    }
  }

  private func setupVisibleElements(createButton: @escaping (Element) -> UIButton) {
    disposeBag {
      _visibleElements ==> { [weak self] in self?.recreateButtons(visibleElements: $0) }

      _visibleElements
        .withLatestFrom(selectedElement) { [selectionStrategy] visible, selected -> Element? in
          switch selectionStrategy {
          case .singleElement:
            return visible.contains { $0 == selected } ? selected : visible.first
          case .singleElementOrNil:
            return visible.contains { $0 == selected } ? selected : nil
          }
        } ==> _selectedElement
    }
  }

  private func recreateButtons(visibleElements: [Element]) {
    let buttons = visibleElements.map { createButton($0) }
    
    horizontalStack?.removeArrangedSubviews()
    horizontalStack?.addArrangedSubviews(buttons)

    zip(buttons, visibleElements)
      .forEach { button, element in bindButton(button, to: element) }

    invalidateIntrinsicContentSize()
    setNeedsLayout()
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

    disposeBag {
      selectedElement.isEqual(to: element) ==> button.rx.isSelected
      elementToSelect ==> _userDidSelectElement
    }
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

    disposeBag {
      programmaticallySelectedElement ==> _selectedElement
    }
  }
  
  private func setupInitialState(visibleElements: [Element]) {
      self.visibleElements.onNext(visibleElements)
  }
}
