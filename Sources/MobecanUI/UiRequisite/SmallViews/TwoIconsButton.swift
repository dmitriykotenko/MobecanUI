// Copyright © 2020 Mobecan. All rights reserved.

import Kingfisher
import LayoutKit
import RxCocoa
import RxSwift
import UIKit


public class TwoIconsButton: LayoutableView {
  
  public struct Subviews {

    public let leadingIconView: UIImageView
    public let titleLabel: UILabel
    public let trailingIconView: UIImageView
    public let loadingIndicator: ActivityIndicatorProtocol
    
    public init(leadingIconView: UIImageView,
                titleLabel: UILabel,
                trailingIconView: UIImageView,
                loadingIndicator: ActivityIndicatorProtocol) {
      self.leadingIconView = leadingIconView
      self.titleLabel = titleLabel
      self.trailingIconView = trailingIconView
      self.loadingIndicator = loadingIndicator
    }
  }
  
  public struct Foreground {
    
    public let leadingIcon: UIImage?
    public let title: String?
    public let trailingIcon: UIImage?
    
    public init(leadingIcon: UIImage? = nil,
                title: String? = nil,
                trailingIcon: UIImage? = nil) {
      self.leadingIcon = leadingIcon
      self.title = title
      self.trailingIcon = trailingIcon
    }
  }
  
  public var tap: Observable<Void> { tapGesture.when(.recognized).mapToVoid() }

  @RxUiInput(false) public var isLoading: AnyObserver<Bool>

  private let leadingIconView: UIImageView
  private let titleLabel: UILabel
  private let trailingIconView: UIImageView
  
  private let loadingIndicator: ActivityIndicatorProtocol
  
  private lazy var tapGesture = rx.tapGesture()
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(subviews: Subviews,
              foreground: Foreground,
              height: CGFloat,
              spacing: CGFloat) {
    self.leadingIconView = subviews.leadingIconView
    self.titleLabel = subviews.titleLabel
    self.trailingIconView = subviews.trailingIconView
    
    self.loadingIndicator = subviews.loadingIndicator
    
    super.init()

    setupLayout(height: height, spacing: spacing)

    highlightOnTaps(disposeBag: disposeBag)
    
    displayIconsAndText(foreground: foreground)
    
    setupIsLoading()
  }
  
  private func setupLayout(height: CGFloat,
                           spacing: CGFloat) {
    layout = InsetLayout<UIView>.fromSingleSubview(
        .hstack(distribution: .fill, spacing: spacing, [
          leadingIconView,
          titleLabel,
          .zstack([trailingIconView, .centered(loadingIndicator)])
        ])
      )
      .with(height: height)
  }
  
  private func displayIconsAndText(foreground: Foreground) {
    leadingIconView.templateImage = foreground.leadingIcon
    leadingIconView.isHidden = (foreground.leadingIcon == nil)
    
    titleLabel.text = foreground.title
    
    trailingIconView.templateImage = foreground.trailingIcon
    trailingIconView.isHidden = (foreground.trailingIcon == nil)
  }
  
  private func setupIsLoading() {
    disposeBag {
      _isLoading ==> trailingIconView.rx.isHidden
      _isLoading ==> loadingIndicator.rxIsAnimating
    }
  }
  
  @discardableResult
  public func foreground(_ foreground: Foreground) -> Self {
    displayIconsAndText(foreground: foreground)
    return self
  }
  
  @discardableResult
  public func tintColors(leadingIcon leadingIconColor: UIColor? = nil,
                         title titleColor: UIColor? = nil,
                         trailingIcon trailingIconColor: UIColor? = nil) -> Self {
    leadingIconColor.map { leadingIconView.tintColor = $0 }
    titleColor.map { titleLabel.textColor = $0 }
    trailingIconColor.map { trailingIconView.tintColor = $0 }
    
    trailingIconColor.map { _ = loadingIndicator.color($0) }

    return self
  }

  override open var forFirstBaselineLayout: UIView {
    titleLabel.forFirstBaselineLayout
  }

  override open var forLastBaselineLayout: UIView {
    titleLabel.forLastBaselineLayout
  }
}
