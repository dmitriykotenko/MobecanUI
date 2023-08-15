// Copyright © 2021 Mobecan. All rights reserved.

import UIKit


public extension UIScrollView {

  /// Аналог свойства ``UIScrollView.contentOffset``, который показывает смещение
  /// от правого нижнего угла видимой части скролл-вью до правого нижнего угла скролл-вьюшного контента.
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
