//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public class EndOfScreenView<Button: TypedButton>: UIView {
  
  public struct Subviews {
    
    public let hintLabel: UILabel
    public let errorLabel: UILabel
    public let button: Button
    public let additionalViews: [UIView]
    
    public init(hintLabel: UILabel,
                errorLabel: UILabel,
                button: Button,
                additionalViews: [UIView]) {
      self.hintLabel = hintLabel
      self.errorLabel = errorLabel
      self.button = button
      self.additionalViews = additionalViews
    }
  }
  
  public let isEnabled: AnyObserver<Bool>
  @RxUiInput(nil) public var hint: AnyObserver<String?>
  @RxUiInput(nil) public var errorText: AnyObserver<String?>

  public var value: AnyObserver<Button.Value?> { button.value }

  @RxDriverOutput(0) public var height: Driver<CGFloat>
  public var buttonTap: Observable<Button.Action> { button.tap }

  public let contentView: UIView
  
  private let hintLabel: UILabel
  private let errorLabel: UILabel
  private let button: Button
  
  private let respectSafeArea: Bool
  
  private lazy var contentFrameListener = FramesListener(views: [contentView])
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(subviews: Subviews,
              spacing: CGFloat,
              insets: UIEdgeInsets,
              respectSafeArea: Bool = true,
              isEnabled: AnyObserver<Bool>) {
    self.hintLabel = subviews.hintLabel
    self.errorLabel = subviews.errorLabel
    self.button = subviews.button
    
    self.respectSafeArea = respectSafeArea
    self.isEnabled = isEnabled
    
    self.contentView = UIView.vstack(
      spacing: spacing,
      [hintLabel] +
      subviews.additionalViews +
      [errorLabel] +
      [button],
      insets: insets
    )
    
    super.init(frame: .zero)

    addSubviews()
    setupLabels()
    setupHeightSignal()
  }
  
  private func addSubviews() {
    putSubview(
      respectSafeArea ? .safeAreaZstack([contentView]) : contentView
    )
  }
  
  private func setupLabels() {
    [
      _hint.bind(to: hintLabel.rx.text),
      _hint.map { $0 == nil }.bind(to: hintLabel.rx.isHidden),
    
      _errorText.bind(to: errorLabel.rx.text),
      _errorText.map { $0 == nil }.bind(to: errorLabel.rx.isHidden)
    ]
    .disposed(by: disposeBag)
  }
  
  private func setupHeightSignal() {
    contentFrameListener.framesChanged
      .compactMap { [weak self] in self?.contentView.frame.height }
      .bind(to: _height)
      .disposed(by: disposeBag)
  }
}


public extension EndOfScreenView where Button.Value == ButtonForeground {
  
  var title: AnyObserver<String?> {
    .onNext { [weak self] in
      self?.value.onNext(.title($0))
    }
  }
}


public extension EndOfScreenView where Button: LoadingButton {

  convenience init(subviews: Subviews,
                   spacing: CGFloat,
                   insets: UIEdgeInsets,
                   respectSafeArea: Bool = true) {
    self.init(
      subviews: subviews,
      spacing: spacing,
      insets: insets,
      respectSafeArea: respectSafeArea,
      isEnabled: subviews.button.rx.isEnabled.asObserver()
    )
  }

  var isLoading: AnyObserver<Bool> { button.rx.isLoading.asObserver() }
}
