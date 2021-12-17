//  Copyright © 2020 Mobecan. All rights reserved.

import Kingfisher
import RxCocoa
import RxSwift
import UIKit


open class TwoIconsButton: UIView {
  
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
  
  open var tap: Observable<Void> { tapGesture.when(.recognized).mapToVoid() }

  /// If non-zero, extends tap area outside button's frame (usually used for small buttons).
  open var tapInsets: UIEdgeInsets = .zero

  @RxUiInput(false) open var isLoading: AnyObserver<Bool>

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
    
    super.init(frame: .zero)
    
    _ = self.height(height)
    
    addSubviews(spacing: spacing)
    highlightOnTaps(disposeBag: disposeBag)
    
    displayIconsAndText(foreground: foreground)
    
    setupIsLoading()
  }
  
  private func addSubviews(spacing: CGFloat) {
    putSubview(
      .hstack(distribution: .fill, spacing: spacing, [
        leadingIconView,
        titleLabel,
        .zstack([trailingIconView, .centered(loadingIndicator)])
      ])
    )
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
  
  open func foreground(_ foreground: Foreground) -> Self {
    displayIconsAndText(foreground: foreground)
    return self
  }
  
  open func tintColors(leadingIcon leadingIconColor: UIColor? = nil,
                       title titleColor: UIColor? = nil,
                       trailingIcon trailingIconColor: UIColor? = nil) -> Self {
    leadingIconColor.map { leadingIconView.tintColor = $0 }
    titleColor.map { titleLabel.textColor = $0 }
    trailingIconColor.map { trailingIconView.tintColor = $0 }
    
    trailingIconColor.map { _ = loadingIndicator.color($0) }

    return self
  }

  override open func point(inside point: CGPoint,
                           with event: UIEvent?) -> Bool {
    let extendedBounds = bounds.inset(by: tapInsets)
    return extendedBounds.contains(point)
  }

  override open var forFirstBaselineLayout: UIView {
    titleLabel.forFirstBaselineLayout
  }

  override open var forLastBaselineLayout: UIView {
    titleLabel.forLastBaselineLayout
  }
}
