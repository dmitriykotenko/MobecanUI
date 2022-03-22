// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UITextView {

  /// Adjusts text insets, so the text view looks like UITextField with given height.
  func imitateTextFieldInset(textFieldHeight: CGFloat) -> Self {
    removeDefaultTextInset()
      .adjustVerticalTextInset(minimumHeight: textFieldHeight)
  }

  /// Completely removes default text insets of text view, so it looks more like UITextField.
  ///
  /// Thorough explanation: https://stackoverflow.com/questions/746670/how-to-lose-margin-padding-in-uitextview
  func removeDefaultTextInset() -> Self {
    textContainerInset(.zero).lineFragmentPadding(0)
  }

  /// Adjusts vertical text alignment.
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
