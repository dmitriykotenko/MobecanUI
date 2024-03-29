// Copyright © 2020 Mobecan. All rights reserved.


import LayoutKit
import RxSwift
import RxCocoa
import SnapKit
import UIKit


open class RadioButton<Element: Equatable>: LayoutableView {

  public enum SelectionStrategy {

    /// Может быть выбрано не больше одного элемента.
    /// При нажатии на выбранный элемент он перестаёт быть выбранным.
    case singleElementOrNil

    /// Всегда выбран ровно один элемент. Нажатие на выбранный элемент не даёт никакого эффекта.
    case singleElement
  }

  // MARK: - Inputs and outputs
  @RxUiInput([]) public var visibleElements: AnyObserver<[Element]>
  @RxUiInput public var selectElement: AnyObserver<Element?>
  @RxDriverOutput(nil) public var selectedElement: Driver<Element?>
  @RxSignalOutput public var userDidSelectElement: Signal<Element?>

  // MARK: - Subviews
  private var horizontalStack: StackView?
  
  private let initElementButton: (Element) -> UIControl
  private let selectionStrategy: SelectionStrategy
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initialization
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(visibleElements: [Element],
              initElementButton: @escaping (Element) -> UIControl,
              selectionStrategy: SelectionStrategy = .singleElement,
              distribution: UIStackView.Distribution = .fillEqually,
              spacing: CGFloat = 0,
              insets: UIEdgeInsets = .zero) {

    self.initElementButton = initElementButton
    self.selectionStrategy = selectionStrategy

    super.init()

    setupHorizontalStack(distribution: distribution, spacing: spacing, insets: insets)
    setupVisibleElements()

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

    horizontalStack.map { layout = $0.asLayout }
  }

  private func setupVisibleElements() {
    disposeBag {
      _visibleElements ==> { [weak self] in self?.recreateElementButtons(visibleElements: $0) }

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

  private func recreateElementButtons(visibleElements: [Element]) {
    let elementButtons = visibleElements.map { initElementButton($0) }
    
    horizontalStack?.removeArrangedSubviews()
    horizontalStack?.addArrangedSubviews(elementButtons)

    zip(elementButtons, visibleElements)
      .forEach { button, element in bindButton(button, to: element) }

    invalidateIntrinsicContentSize()
    setNeedsLayoutAndPropagate()
  }
  
  private func bindButton(_ button: UIControl,
                          to element: Element) {
    let tappedElement = button.rx.controlEvent(.touchUpInside).map { _ -> Element in element }
    
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
          // Не даём выделять невидимые элементы.
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
