//  Copyright © 2020 Mobecan. All rights reserved.

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
    numberOfLines(1).lineBreakMode(.byTruncatingTail)
  }

  func multilined() -> Self {
    numberOfLines(0).lineBreakMode(.byWordWrapping)
  }

  func images(_ imagesByState: [(UIControl.State, image: UIImage)]) -> Self {
    imagesByState.forEach { setImage($1, for: $0) }
    return self
  }

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

  func titleTransformer(_ titleTransformer: @escaping (String?) -> String?) -> Self {
    self.titleTransformer = titleTransformer
    return self
  }
}


public extension TabButton {
  
  func colors(_ colors: [ButtonColorsState]) -> Self {
    self.colorsByState = colors
    return self
  }
}
