//  Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import UIKit


public extension Layout {

  func withInsets(_ insets: UIEdgeInsets) -> Layout {
    InsetLayout(
      insets: insets,
      sublayout: self
    )
  }

  func with(width: CGFloat? = nil,
            height: CGFloat? = nil) -> Layout {
    SizeLayout<UIView>(
      minWidth: width,
      maxWidth: width,
      minHeight: height,
      maxHeight: height,
      sublayout: self
    )
  }

  func with(size: CGSize) -> Layout {
    SizeLayout<UIView>(
      size: size,
      sublayout: self
    )
  }

  func with(minimumWidth: CGFloat? = nil,
            minimumHeight: CGFloat? = nil) -> Layout {
    SizeLayout<UIView>(
      minWidth: minimumWidth,
      minHeight: minimumHeight,
      sublayout: self
    )
  }

  func with(minimumSize: CGSize) -> Layout {
    SizeLayout<UIView>(
      minSize: minimumSize,
      sublayout: self
    )
  }

  func with(maximumWidth: CGFloat? = nil,
            maximumHeight: CGFloat? = nil) -> Layout {
    SizeLayout<UIView>(
      maxWidth: maximumWidth,
      maxHeight: maximumHeight,
      sublayout: self
    )
  }

  func with(maximumSize: CGSize) -> Layout {
    SizeLayout<UIView>(
      maxSize: maximumSize,
      sublayout: self
    )
  }
}
