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
  
  public init(initLabel: @escaping () -> UILabel) {
    self.initLabel = initLabel
  }
  
  public func setup(contentView: ContentView,
                    containerView: UIView) -> ActionsViewStructs.Ingredient<ContentView.Value, State, Event> {
    let errorView = ErrorContainer(
      contentView: contentView,
      containerView: containerView,
      errorLabel: initLabel()
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
  
  private var contentViewBottom: Constraint?
  private var errorLabelBottom: Constraint?
  
  private let disposeBag = DisposeBag()
  
  required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  init(contentView: UIView,
       containerView: UIView,
       errorLabel: UILabel) {
    self.contentView = contentView
    self.containerView = containerView
    self.errorLabel = errorLabel
    
    super.init(frame: .zero)
    
    addSubviews()
   
    pinContentViewToErrorLabel()
    initBottomConstraints()
    displayError()
  }
  
  private func addSubviews() {
    putSubview(
      .zstack([
        .veryFlexibleContainer(errorLabel),
        containerView
      ])
    )
  }
  
  private func pinContentViewToErrorLabel() {
    contentView.forLastBaselineLayout.snp.makeConstraints {
      $0.leading.equalTo(errorLabel)
      $0.bottom.equalTo(errorLabel.snp.top)
    }
  }
  
  private func initBottomConstraints() {
    contentView.snp.makeConstraints {
      contentViewBottom = $0.bottom.equalToSuperview().constraint
    }
    
    errorLabel.snp.makeConstraints {
      errorLabelBottom = $0.bottom.equalToSuperview().constraint
    }
  }
  
  private func displayError() {
    guard
      let contentViewBottom = contentViewBottom,
      let errorLabelBottom = errorLabelBottom
      else { return }
    
    let errorIsNil = _errorText.map { $0.isNilOrEmpty }
    
    [
      _errorText.bind(to: errorLabel.rx.text),
      errorIsNil.bind(to: errorLabel.rx.isHidden),
      errorIsNil.bind(to: contentViewBottom.rx.isActive),
      errorIsNil.bind(to: errorLabelBottom.rx.isActive)
    ]
    .disposed(by: disposeBag)
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
