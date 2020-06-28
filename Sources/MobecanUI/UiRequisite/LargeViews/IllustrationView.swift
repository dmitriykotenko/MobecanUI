//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public class IllustrationView: UIView {
  
  public struct Subviews {
    
    public let illustrationView: UIImageView
    public let titleLabel: UILabel
    public let subtitleLabel: UILabel
    
    public init(illustrationView: UIImageView,
                titleLabel: UILabel,
                subtitleLabel: UILabel) {
      self.illustrationView = illustrationView
      self.titleLabel = titleLabel
      self.subtitleLabel = subtitleLabel
    }
  }

  public var illustration: AnyObserver<UIImage?> { illustrationView.rx.image.asObserver() }
  public var title: AnyObserver<String?> { titleLabel.rx.text.asObserver() }
  public var subtitle: AnyObserver<String?> { subtitleLabel.rx.text.asObserver() }
  
  public let illustrationView: UIImageView
  public let titleLabel: UILabel
  public let subtitleLabel: UILabel
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(subviews: Subviews,
              illustration: UIImage? = nil,
              title: String? = nil,
              subtitle: String? = nil,
              illustrationToTitleSpacing: CGFloat = 0,
              titleToSubtitleSpacing: CGFloat = 0) {
    self.illustrationView = subviews.illustrationView
    self.titleLabel = subviews.titleLabel
    self.subtitleLabel = subviews.subtitleLabel
    
    super.init(frame: .zero)
    
    putSubview(
      .vstack(
        alignment: .center,
        [
          illustrationView,
          .spacer(height: illustrationToTitleSpacing),
          titleLabel,
          .spacer(height: titleToSubtitleSpacing),
          subtitleLabel
        ]
      )
    )
    
    illustration.map { self.illustration.onNext($0) }
    title.map { self.title.onNext($0) }
    subtitle.map { self.subtitle.onNext($0) }
  }
}
