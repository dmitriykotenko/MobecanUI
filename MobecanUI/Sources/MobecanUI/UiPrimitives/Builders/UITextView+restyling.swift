//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UITextView {
  
  // Fixes horizontal and vertical insets of text view, so it looks like UITextField.
  // Thorough explanation: https://stackoverflow.com/questions/746670/how-to-lose-margin-padding-in-uitextview
  func removeDefaultTextInset() -> Self {
    return textContainerInset(.zero).lineFragmentPadding(0)
  }

  /// Adjusts vertical text alignment, so the text view looks like UITextField with same minimum height.
  func adjustVerticalTextInset(minimumHeight: CGFloat) -> Self {
    guard let font = font else { return self }
    
    let verticalInset = (minimumHeight - font.lineHeight) / 2

    textContainerInset = textContainerInset.with(
      top: verticalInset,
      bottom: verticalInset
    )
    
    return self
  }
}
