//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


public class NavigationBar: ClickThroughView {
  
  public struct Subviews {
    
    public let leftButton: UIButton
    public let rightButton: UIButton
    public let titleLabel: UILabel
    
    public init(leftButton: UIButton,
                rightButton: UIButton,
                titleLabel: UILabel) {
      self.leftButton = leftButton
      self.rightButton = rightButton
      self.titleLabel = titleLabel
    }
  }
  
  @RxUiInput(nil) public var title: AnyObserver<String?>
  @RxUiInput(.none) public var backButtonStyle: AnyObserver<NavigationButtonStyle>
  @RxUiInput(.none) public var rightButtonStyle: AnyObserver<NavigationButtonStyle>
  @RxUiInput(nil) public var screenBackgroundColor: AnyObserver<UIColor?>
  
  public var leftButtonTap: Observable<Void> { leftButton.rx.tap.asObservable() }
  public var rightButtonTap: Observable<Void> { rightButton.rx.tap.asObservable() }
  
  private let leftButton: UIButton
  private let rightButton: UIButton
  private let titleLabel: UILabel

  private let leftButtonBackground = SausageView()
  private let rightButtonBackground = SausageView()
  private let titleLabelBackground = SausageView()

  private let applyButtonStyle: (UIButton, NavigationButtonStyle) -> Void
  private let backgroundBlurStyle: (UIColor?) -> UIBlurEffect.Style?
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(subviews: Subviews,
              height: CGFloat,
              spacing: CGFloat,
              applyButtonStyle: @escaping (UIButton, NavigationButtonStyle) -> Void,
              backgroundBlurStyle: @escaping (UIColor?) -> UIBlurEffect.Style? = { _ in nil }) {
    self.leftButton = subviews.leftButton
    self.rightButton = subviews.rightButton
    self.titleLabel = subviews.titleLabel
    
    self.applyButtonStyle = applyButtonStyle
    self.backgroundBlurStyle = backgroundBlurStyle
    
    super.init(frame: .zero)
    
    insertSubviews()
    
    setupLayout(
      height: height,
      leftButton: leftButton,
      rightButton: rightButton,
      titleLabel: titleLabel,
      spacing: spacing
    )
    
    [
      _backButtonStyle.subscribe(onNext: { applyButtonStyle(subviews.leftButton, $0) }),
      _backButtonStyle.map { $0 == .none }.bind(to: leftButtonBackground.rx.isHidden),
      
      _rightButtonStyle.subscribe(onNext: { applyButtonStyle(subviews.rightButton, $0) }),
      _rightButtonStyle.map { $0 == .none }.bind(to: rightButtonBackground.rx.isHidden),

      _title.bind(to: titleLabel.rx.text),
      _title.map { $0.isNilOrEmpty }.bind(to: titleLabelBackground.rx.isHidden),
      
      _screenBackgroundColor.asObservable()
        .nestedFlatMap { [weak self] in self?.backgroundBlurStyle($0) }
        .subscribe(onNext: { [weak self] in self?.setBlurStyle($0) })
    ]
    .disposed(by: disposeBag)
  }
  
  open func insertSubviews() {
    addSubview(leftButtonBackground)
    addSubview(rightButtonBackground)
    addSubview(titleLabelBackground)
    
    addSubview(leftButton)
    addSubview(rightButton)
    addSubview(titleLabel)
  }

  open func setupLayout(height: CGFloat,
                        leftButton: UIButton,
                        rightButton: UIButton,
                        titleLabel: UILabel,
                        spacing: CGFloat) {
    pin(leftButtonBackground, to: leftButton, inset: 8)
    pin(rightButtonBackground, to: rightButton, inset: 8)
    pin(titleLabelBackground, to: titleLabel, horizontalInset: -16, verticalInset: -8)
  }
  
  private func pin(_ viewBackground: UIView, to view: UIView, inset: CGFloat) {
    viewBackground.snp.makeConstraints {
      $0.centerX.equalTo(view)
      $0.top.bottom.equalTo(view).inset(inset)
      $0.left.lessThanOrEqualTo(view).inset(inset)
      $0.right.greaterThanOrEqualTo(view).inset(inset)
      $0.width.greaterThanOrEqualTo(viewBackground.snp.height)
    }
  }
  
  private func pin(_ labelBackground: UIView,
                   to label: UILabel,
                   horizontalInset: CGFloat,
                   verticalInset: CGFloat) {
    labelBackground.snp.makeConstraints {
      $0.leading.trailing.equalTo(label).inset(horizontalInset)
      $0.centerY.equalTo(label)
      $0.height.equalTo(label.font.lineHeight - 2 * verticalInset)
    }
  }

  open func setBlurStyle(_ blurStyle: UIBlurEffect.Style?) {
    blur(leftButtonBackground, with: blurStyle)
    blur(rightButtonBackground, with: blurStyle)
    blur(titleLabelBackground, with: blurStyle)
  }
  
  private func blur(_ view: UIView,
                    with blurStyle: UIBlurEffect.Style?) {
    view.subviews.forEach { $0.removeFromSuperview() }

    blurStyle.map {
      view.addSingleSubview(.blur(style: $0))
    }
  }

  open var affectsSafeArea: Bool { true }
}
