//  Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import UIKit


public extension UIView {

  static func zstack(_ subviews: [UIView],
                     insets: UIEdgeInsets = .zero) -> LayoutableView {
    LayoutableView(
      layout: ZstackLayout(
          sublayouts: subviews.map(\.asLayout)
        )
        .withInsets(insets)
    )
  }

  static func safeAreaZstack(_ subviews: [UIView],
                             insets: UIEdgeInsets = .zero) -> LayoutableView {
    SafeAreaZstackView(
      subviews: subviews,
      insets: insets
    )
  }
}


private class SafeAreaZstackView: LayoutableView {

  required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  init(subviews: [UIView],
       insets: UIEdgeInsets = .zero) {
    super.init()

    layout = SafeAreaLayout(
      owningView: self,
      sublayout:
        ZstackLayout(
          sublayouts: subviews.map(\.asLayout)
        )
        .withInsets(insets)
    )
  }
}
