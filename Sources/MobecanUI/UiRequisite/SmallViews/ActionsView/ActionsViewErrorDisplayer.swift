//  Copyright © 2020 Mobecan. All rights reserved.

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


private class ErrorContainer: UIView {
  
  @RxUiInput(nil) var errorText: AnyObserver<String?>
  
  private let contentView: UIView
  private let containerView: UIView
  private let errorLabel: UILabel
  private let errorLabelInsets: UIEdgeInsets
  private let displayError: (String?) -> ActionsViewStructs.ErrorContainerState
  
  private var containerViewBottom: Constraint?
  private var errorLabelBottom: Constraint?
  
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
    
    super.init(frame: .zero)
    
    addSubviews()
   
    pinContentViewToErrorLabel()
    initBottomConstraints()
    setupErrorDisplaying()
  }
  
  private func addSubviews() {
    putSubview(
      .zstack([
        .veryFlexibleContainer(errorLabel),
        containerView
      ])
    )

    _ = cornerRadius(contentView.layer.cornerRadius)
  }
  
  private func pinContentViewToErrorLabel() {
    contentView.forLastBaselineLayout.snp.makeConstraints {
      $0.leading.equalTo(errorLabel).inset(-errorLabelInsets.left)
      $0.trailing.equalTo(errorLabel).inset(-errorLabelInsets.right)
      $0.bottom.equalTo(errorLabel.snp.top).inset(-errorLabelInsets.top)
    }
  }
  
  private func initBottomConstraints() {
    containerView.snp.makeConstraints {
      containerViewBottom = $0.bottom.equalToSuperview().constraint
    }
    
    errorLabel.snp.makeConstraints {
      errorLabelBottom = $0.bottom.equalToSuperview().inset(errorLabelInsets.bottom).constraint
    }
  }
  
  private func setupErrorDisplaying() {
    _errorText
      .subscribe(onNext: { [weak self] in self?.display(errorText: $0) })
      .disposed(by: disposeBag)
  }

  private func display(errorText: String?) {
    guard
      let containerViewBottom = containerViewBottom,
      let errorLabelBottom = errorLabelBottom
      else { return }

    let stateToDisplay = displayError(errorText)
    let errorTextToDisplay = stateToDisplay.errorText

    let errorIsNil = errorTextToDisplay.isNilOrEmpty

    errorLabel.text = errorTextToDisplay
    errorLabel.isVisible = !errorIsNil
    backgroundColor = stateToDisplay.backgroundColor

    containerViewBottom.isActive = errorIsNil
    errorLabelBottom.isActive = !errorIsNil
  }
}


private extension UIView {
  
  static func veryFlexibleContainer(_ subview: UIView) -> UIView {
    let containerView = UIView()
    
    containerView.addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.left.greaterThanOrEqualToSuperview()
      $0.right.lessThanOrEqualToSuperview()
    }
    
    return containerView
  }
}
