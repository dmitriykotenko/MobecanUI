// Copyright © 2021 Mobecan. All rights reserved.

import UIKit


public extension UIScrollView {

  /// Bottom-right counterpart of .contentOffset property.
  ///
  /// Horizontal and vertical distance
  /// between scroll view's visible area bottom-right corner and scroll view content's bottom-right corner.
  var oppositeContentOffset: CGPoint {
    let visibleAreaBottomRightCorner = contentOffset + frame.size

    let contentSizeIncludingInsets = contentSize + adjustedContentInset.asSize

    let contentBottomRightCorner = CGPoint(
      x: contentSizeIncludingInsets.width,
      y: contentSizeIncludingInsets.height
    )

    return contentBottomRightCorner - visibleAreaBottomRightCorner
  }
}


private extension UIEdgeInsets {

  var asSize: CGSize {
    .init(
      width: left + right,
      height: top + bottom
    )
  }
}
