// Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import UIKit


public extension Layout {

  func withInsets(_ insets: UIEdgeInsets) -> InsetLayout<UIView> {
    InsetLayout(
      insets: insets,
      sublayout: self
    )
  }

  func with(width: CGFloat? = nil,
            height: CGFloat? = nil) -> SizeLayout<UIView> {
    SizeLayout<UIView>(
      minWidth: width,
      maxWidth: width,
      minHeight: height,
      maxHeight: height,
      sublayout: self
    )
  }

  func with(size: CGSize) -> SizeLayout<UIView> {
    SizeLayout<UIView>(
      size: size,
      sublayout: self
    )
  }

  func with(minimumWidth: CGFloat? = nil,
            minimumHeight: CGFloat? = nil) -> SizeLayout<UIView> {
    SizeLayout<UIView>(
      minWidth: minimumWidth,
      minHeight: minimumHeight,
      sublayout: self
    )
  }

  func with(minimumSize: CGSize) -> SizeLayout<UIView> {
    SizeLayout<UIView>(
      minSize: minimumSize,
      sublayout: self
    )
  }

  func with(maximumWidth: CGFloat? = nil,
            maximumHeight: CGFloat? = nil) -> SizeLayout<UIView> {
    SizeLayout<UIView>(
      maxWidth: maximumWidth,
      maxHeight: maximumHeight,
      sublayout: self
    )
  }

  func with(maximumSize: CGSize) -> SizeLayout<UIView> {
    SizeLayout<UIView>(
      maxSize: maximumSize,
      sublayout: self
    )
  }
}
