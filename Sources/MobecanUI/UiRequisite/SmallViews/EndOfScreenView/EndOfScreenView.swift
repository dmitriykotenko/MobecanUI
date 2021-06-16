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

  public struct Layout {
    public var arrange: (Subviews) -> (contentView: UIView, containerView: UIView)

    public init(arrange: @escaping (Subviews) -> (contentView: UIView, containerView: UIView)) {
      self.arrange = arrange
    }
  }

  public let isEnabled: AnyObserver<Bool>
  @RxUiInput(nil) public var hint: AnyObserver<String?>
  @RxUiInput(nil) public var errorText: AnyObserver<String?>

  public var value: AnyObserver<Button.Value?> { button.value }

  @RxDriverOutput(0) public var height: Driver<CGFloat>
  public var buttonTap: Observable<Button.Action> { button.tap }

  public let contentView: UIView

  private var hintLabel: UILabel
  private var errorLabel: UILabel
  private var button: Button
  
  private let layout: Layout
  
  private lazy var contentFrameListener = FramesListener(views: [contentView])
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public convenience init(subviews: Subviews,
                          spacing: CGFloat,
                          insets: UIEdgeInsets,
                          respectSafeArea: Bool = true,
                          isEnabled: AnyObserver<Bool>) {
    self.init(
      subviews: subviews,
      layout: .vertical(spacing: spacing, insets: insets, respectSafeArea: respectSafeArea),
      isEnabled: isEnabled
    )
  }

  public init(subviews: Subviews,
              layout: Layout,
              isEnabled: AnyObserver<Bool>) {
    self.hintLabel = subviews.hintLabel
    self.errorLabel = subviews.errorLabel
    self.button = subviews.button

    self.layout = layout
    self.isEnabled = isEnabled

    let (contentView, containerView) = layout.arrange(subviews)

    self.contentView = contentView
    
    super.init(frame: .zero)

    disableTemporaryConstraints()
    putSubview(containerView)

    setupLabels()
    setupHeightSignal()
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
