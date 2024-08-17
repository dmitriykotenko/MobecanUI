// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIButton {

  @discardableResult
  func contentEdgeInsets(_ contentEdgeInsets: UIEdgeInsets) -> Self {
    self.contentEdgeInsets = contentEdgeInsets
    return self
  }
  
  @discardableResult
  func font(_ font: UIFont) -> Self {
    titleLabel?.font = font
    return self
  }
  
  @discardableResult
  func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
    titleLabel?.textAlignment = textAlignment
    
    return self
  }
  
  @discardableResult
  func contentHorizontalAlignment(_ alignment: UIControl.ContentHorizontalAlignment) -> Self {
    self.contentHorizontalAlignment = alignment
    return self
  }
  
  @discardableResult
  func contentVerticalAlignment(_ alignment: UIControl.ContentVerticalAlignment) -> Self {
    self.contentVerticalAlignment = alignment
    return self
  }

  @discardableResult
  func title(_ title: String) -> Self {
    setTitle(title, for: UIControl.State.normal)
    
    setContentCompressionResistancePriority(.required, for: .horizontal)
    setContentCompressionResistancePriority(.required, for: .vertical)
    
    return self
  }
  
  @discardableResult
  func image(_ image: UIImage) -> Self {
    setImage(image, for: UIControl.State.normal)
    
    setContentCompressionResistancePriority(.required, for: .horizontal)
    setContentCompressionResistancePriority(.required, for: .vertical)
    
    return self
  }
  
  @discardableResult
  func foreground(_ foreground: ButtonForeground) -> Self {
    foreground.title.map { _ = title($0) }
    foreground.image.map { _ = image($0) }
    return self
  }

  @discardableResult
  func attributedTitle(_ attributedTitle: NSAttributedString) -> Self {
    setAttributedTitle(attributedTitle, for: UIControl.State.normal)
    
    setContentCompressionResistancePriority(.required, for: .horizontal)
    setContentCompressionResistancePriority(.required, for: .vertical)
    
    return self
  }
  
  @discardableResult
  func textStyle(_ textStyle: TextStyle) -> Self {
    setTextStyle(textStyle)
    return self
  }
  
  
  @discardableResult
  func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
    titleLabel?.lineBreakMode = lineBreakMode
    return self
  }
  
  @discardableResult
  func numberOfLines(_ numberOfLines: Int) -> Self {
    titleLabel?.numberOfLines = numberOfLines
    return self
  }
  
  /// Adjusts vertical text alignment,
  /// so the first line of multiline title aligns vertically
  /// with title of single-line button with same font and same minimum height.
  @discardableResult
  func adjustVerticalTextInset(minimumHeight: CGFloat) -> Self {
    guard let font = titleLabel?.font else { return self }
    
    let verticalInset = (minimumHeight - font.lineHeight) / 2

    contentEdgeInsets = contentEdgeInsets.with(
      top: verticalInset,
      bottom: verticalInset
    )
    
    return self
  }

  @discardableResult
  func singlelined() -> Self {
    numberOfLines(1).lineBreakMode(.byTruncatingTail)
  }

  @discardableResult
  func multilined() -> Self {
    numberOfLines(0).lineBreakMode(.byWordWrapping)
  }

  @discardableResult
  func images(_ imagesByState: [(UIControl.State, image: UIImage)]) -> Self {
    imagesByState.forEach { setImage($1, for: $0) }
    return self
  }

  @discardableResult
  func imageTitlePadding(_ imageTitleSpacing: CGFloat,
                         forContentInsets contentInsets: UIEdgeInsets = .zero) -> Self {
    contentEdgeInsets = UIEdgeInsets(
      top: contentInsets.top,
      left: contentInsets.left,
      bottom: contentInsets.bottom,
      right: contentInsets.right + imageTitleSpacing
    )
    
    titleEdgeInsets = UIEdgeInsets(
      top: 0,
      left: imageTitleSpacing,
      bottom: 0,
      right: -imageTitleSpacing
    )
    
    return self
  }
}


public extension DiverseButton {
  
  @discardableResult
  func tapInsets(_ tapInsets: UIEdgeInsets) -> Self {
    self.tapInsets = tapInsets
    return self
  }
  
  @discardableResult
  func colors(_ colors: [ButtonColorsState]) -> Self {
    self.colorsByState = colors
    return self
  }
  
  @discardableResult
  func alphas(_ alphas: [(UIControl.State, alpha: CGFloat)]) -> Self {
    self.alphasByState = alphas
    return self
  }

  @discardableResult
  func nativeSizePolicy(_ nativeSizePolicy: NativeSizePolicy) -> Self {
    self.nativeSizePolicy = nativeSizePolicy
    return self
  }

  @discardableResult
  func titleTransformer(_ titleTransformer: @escaping (String?) -> String?) -> Self {
    self.titleTransformer = titleTransformer
    return self
  }
}


public extension IconTextButton {

  @discardableResult
  func spacingAwareContentEdgeInsets(_ spacingAwareInsets: UIEdgeInsets) -> Self {
    self.spacingAwareContentEdgeInsets = spacingAwareInsets
    return self
  }
}


public extension TabButton {
  
  @discardableResult
  func colors(_ colors: [ButtonColorsState]) -> Self {
    self.colorsByState = colors
    return self
  }
}
