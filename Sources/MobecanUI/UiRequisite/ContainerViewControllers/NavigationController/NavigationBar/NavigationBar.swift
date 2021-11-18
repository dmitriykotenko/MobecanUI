//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


open class NavigationBar: ClickThroughView {
  
  public struct Subviews {
    
    public let leftButton: UIButton
    public let titleView: LabelOrView
    public let subtitleView: LabelOrView
    public let backgroundView: BackgroundView
    
    public init(leftButton: UIButton,
                titleView: LabelOrView,
                subtitleView: LabelOrView,
                backgroundView: BackgroundView) {
      self.leftButton = leftButton
      self.titleView = titleView
      self.subtitleView = subtitleView
      self.backgroundView = backgroundView
    }
  }
  
  @RxUiInput(.none) public var backButtonStyle: AnyObserver<NavigationButtonStyle>
  @RxUiInput(.empty) public var content: AnyObserver<NavigationBarContent>
  @RxUiInput(nil) public var screenBackgroundColor: AnyObserver<UIColor?>
  
  public var leftButtonTap: Observable<Void> { leftButton.rx.tap.asObservable() }
  
  private let leftButton: UIButton
  private let rightViewContainer = UIView.stretchableSpacer()
  
  private let titleView: LabelOrView
  private let subtitleView: LabelOrView
  private let backgroundView: BackgroundView

  private let applyButtonStyle: (UIButton, NavigationButtonStyle) -> Void
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(subviews: Subviews,
              height: CGFloat,
              spacing: CGFloat,
              applyButtonStyle: @escaping (UIButton, NavigationButtonStyle) -> Void) {
    self.leftButton = subviews.leftButton
    self.titleView = subviews.titleView
    self.subtitleView = subviews.subtitleView
    self.backgroundView = subviews.backgroundView
    
    self.applyButtonStyle = applyButtonStyle
    
    super.init(frame: .zero)
    
    insertSubviews()
    
    setupLayout(
      subviews: subviews,
      rightViewContainer: rightViewContainer,
      spacing: spacing
    )
    
    disposeBag {
      _backButtonStyle ==> { applyButtonStyle(subviews.leftButton, $0) }
      _content ==> { [weak self] in self?.displayContent($0) }
      _screenBackgroundColor ==> { [weak self] in self?.screenBackgroundColorUpdated($0) }
    }
  }
  
  open func insertSubviews() {
    addSubview(backgroundView)
    
    addSubview(leftButton)
    addSubview(titleView)
    addSubview(subtitleView)
    addSubview(rightViewContainer)
  }
  
  open func setupLayout(subviews: Subviews,
                        rightViewContainer: UIView,
                        height: CGFloat? = nil,
                        spacing: CGFloat) {
    
    subviews.backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }

  open func displayContent(_ content: NavigationBarContent) {
    titleView.value =^ content.title
    subtitleView.value =^ content.subtitle
    
    rightViewContainer.putSingleSubview(
      .vstack(content.rightView.asSequence)
    )
    
    backgroundView.value =^ content.background
  }
  
  open func screenBackgroundColorUpdated(_ screenBackgroundColor: UIColor?) {}

  open var affectsSafeArea: Bool { true }

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    systemLayoutSizeFitting(size)
  }
}
