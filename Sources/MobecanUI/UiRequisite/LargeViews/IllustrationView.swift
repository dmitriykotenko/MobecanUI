//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public class IllustrationView: UIView {

  public var illustration: AnyObserver<UIImage?> { illustrationView.rx.image.asObserver() }
  public var title: AnyObserver<String?> { titleLabel.rx.text.asObserver() }
  public var subtitle: AnyObserver<String?> { subtitleLabel.rx.text.asObserver() }
  
  public let illustrationView: UIImageView
  public let titleLabel: UILabel
  public let subtitleLabel: UILabel
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(subviews: Subviews,
              layout: Layout,
              illustration: UIImage? = nil,
              title: String? = nil,
              subtitle: String? = nil) {
    self.illustrationView = subviews.illustrationView
    self.titleLabel = subviews.titleLabel
    self.subtitleLabel = subviews.subtitleLabel
    
    super.init(frame: .zero)
    
    putSubview(
      layout.mainSubview(subviews: subviews)
    )
    
    illustration.map { self.illustration.onNext($0) }
    title.map { self.title.onNext($0) }
    subtitle.map { self.subtitle.onNext($0) }
  }
}


public extension IllustrationView {

  struct Subviews {

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

  struct Layout {

    public var alignment: UIStackView.Alignment
    public var illustrationToTitleSpacing: CGFloat
    public var titleToSubtitleSpacing: CGFloat

    static let standard = Layout(
      alignment: .center,
      illustrationToTitleSpacing: 0,
      titleToSubtitleSpacing: 0
    )

    func mainSubview(subviews: Subviews) -> UIView {
      .vstack(
        alignment: alignment,
        [
          subviews.illustrationView,
          .spacer(height: illustrationToTitleSpacing),
          subviews.titleLabel,
          .spacer(height: titleToSubtitleSpacing),
          subviews.subtitleLabel
        ]
      )
    }
  }
}
