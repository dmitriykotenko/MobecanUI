//  Copyright © 2019 Mobecan. All rights reserved.

import UIKit


public extension UIButton {
  
  func contentEdgeInsets(_ contentEdgeInsets: UIEdgeInsets) -> Self {
    self.contentEdgeInsets = contentEdgeInsets
    return self
  }
  
  func font(_ font: UIFont) -> Self {
    titleLabel?.font = font
    return self
  }
  
  func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
    titleLabel?.textAlignment = textAlignment
    
    return self
  }
  
  func contentHorizontalAlignment(_ alignment: UIControl.ContentHorizontalAlignment) -> Self {
    self.contentHorizontalAlignment = alignment
    return self
  }
  
  func title(_ title: String) -> Self {
    setTitle(title, for: UIControl.State.normal)
    
    setContentCompressionResistancePriority(.required, for: .horizontal)
    setContentCompressionResistancePriority(.required, for: .vertical)
    
    return self
  }
  
  func image(_ image: UIImage) -> Self {
    setImage(image, for: UIControl.State.normal)
    
    setContentCompressionResistancePriority(.required, for: .horizontal)
    setContentCompressionResistancePriority(.required, for: .vertical)
    
    return self
  }
  
  func foreground(_ foreground: ButtonForeground) -> Self {
    foreground.title.map { _ = title($0) }
    foreground.image.map { _ = image($0) }
    return self
  }

  func attributedTitle(_ attributedTitle: NSAttributedString) -> Self {
    setAttributedTitle(attributedTitle, for: UIControl.State.normal)
    
    setContentCompressionResistancePriority(.required, for: .horizontal)
    setContentCompressionResistancePriority(.required, for: .vertical)
    
    return self
  }
  
  func textStyle(_ textStyle: TextStyle) -> Self {
    setTextStyle(textStyle)
    return self
  }
  
  
  func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
    titleLabel?.lineBreakMode = lineBreakMode
    return self
  }
  
  func numberOfLines(_ numberOfLines: Int) -> Self {
    titleLabel?.numberOfLines = numberOfLines
    return self
  }
  
  /// Adjusts vertical text alignment,
  /// so the first line of multiline title aligns vertically
  /// with title of single-line button with same font and same minimum height.
  func adjustVerticalTextInset(minimumHeight: CGFloat) -> Self {
    guard let font = titleLabel?.font else { return self }
    
    let verticalInset = (minimumHeight - font.lineHeight) / 2

    contentEdgeInsets = contentEdgeInsets.with(
      top: verticalInset,
      bottom: verticalInset
    )
    
    return self
  }

  func singlelined() -> Self {
    return numberOfLines(1).lineBreakMode(.byTruncatingTail)
  }

  func multilined() -> Self {
    return numberOfLines(0).lineBreakMode(.byWordWrapping)
  }

  func imageTitlePadding(_ imageTitlePadding: CGFloat,
                         forContentPadding contentPadding: UIEdgeInsets = .zero) -> Self {
    contentEdgeInsets = UIEdgeInsets(
      top: contentPadding.top,
      left: contentPadding.left,
      bottom: contentPadding.bottom,
      right: contentPadding.right + imageTitlePadding
    )
    
    titleEdgeInsets = UIEdgeInsets(
      top: 0,
      left: imageTitlePadding,
      bottom: 0,
      right: -imageTitlePadding
    )
    
    return self
  }
}


public extension DiverseButton {
  
  func tapInsets(_ tapInsets: UIEdgeInsets) -> Self {
    self.tapInsets = tapInsets
    return self
  }
  
  func colors(_ colors: [ButtonColorsState]) -> Self {
    self.colorsByState = colors
    return self
  }
  
  func alphas(_ alphas: [(UIControl.State, alpha: CGFloat)]) -> Self {
    self.alphasByState = alphas
    return self
  }
}
