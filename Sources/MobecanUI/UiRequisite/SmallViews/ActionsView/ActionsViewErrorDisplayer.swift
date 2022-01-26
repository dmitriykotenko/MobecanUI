// Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit


open class ActionsViewErrorDisplayer<ContentView: DataView & EventfulView>:
ActionsViewIngredientMixer {
  
  public typealias State = String?
  public typealias Event = Void

  private let initLabel: () -> UILabel
  private let labelInsets: UIEdgeInsets
  private let displayError: (String?) -> ActionsViewStructs.ErrorContainerState
  
  public init(
    initLabel: @escaping () -> UILabel,
    labelInsets: UIEdgeInsets = .zero,
    displayError: @escaping (String?) -> ActionsViewStructs.ErrorContainerState = { .init(errorText: $0) }
  ) {
    self.initLabel = initLabel
    self.labelInsets = labelInsets
    self.displayError = displayError
  }
  
  public func setup(contentView: ContentView,
                    containerView: UIView) -> ActionsViewStructs.Ingredient<ContentView.Value, State, Event> {
    let errorView = ErrorContainer(
      contentView: contentView,
      containerView: containerView,
      errorLabel: initLabel(),
      errorLabelInsets: labelInsets,
      displayError: displayError
    )
    
    return .init(
      containerView: errorView,
      value: AnyObserver { _ in },
      state: errorView.errorText,
      events: .never()
    )
  }
}


private class ErrorContainer: LayoutableView {
  
  @RxUiInput(nil) var errorText: AnyObserver<String?>
  
  private let contentView: UIView
  private let containerView: UIView
  private let errorLabel: UILabel
  private let errorLabelInsets: UIEdgeInsets
  private let displayError: (String?) -> ActionsViewStructs.ErrorContainerState
  
  private let disposeBag = DisposeBag()
  
  required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  init(contentView: UIView,
       containerView: UIView,
       errorLabel: UILabel,
       errorLabelInsets: UIEdgeInsets,
       displayError: @escaping (String?) -> ActionsViewStructs.ErrorContainerState) {
    self.contentView = contentView
    self.containerView = containerView
    self.errorLabel = errorLabel
    self.errorLabelInsets = errorLabelInsets
    self.displayError = displayError
    
    super.init()
    
    setupLayout()
    setupErrorDisplaying()
  }
  
  private func setupLayout() {
    layout =
      UIView.vstack([
        containerView,
        errorLabel.withInsets(errorLabelInsets)
      ])
      .asLayout
      .withInsets(.zero)
  }

  private func setupErrorDisplaying() {
    disposeBag {
      _errorText ==> { [weak self] in self?.display(errorText: $0) }
    }
  }

  private func display(errorText: String?) {
    let stateToDisplay = displayError(errorText)
    let errorTextToDisplay = stateToDisplay.errorText

    let errorIsNil = errorTextToDisplay.isNilOrEmpty

    errorLabel.text = errorTextToDisplay
    errorLabel.isVisible = !errorIsNil
    backgroundColor = stateToDisplay.backgroundColor

    setNeedsLayoutAndPropagate()
  }
}
