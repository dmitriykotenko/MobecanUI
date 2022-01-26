// Copyright © 2021 Mobecan. All rights reserved.


import LayoutKit
import UIKit


extension UIView {

  func insideAlignedLayout(alignment: Alignment,
                           insets: UIEdgeInsets) -> LayoutableView {
    let container = LayoutableView(
      layout: InsetLayout<UIView>(
        insets: insets,
        sublayout: AlignedLayout(
          childAlignment: alignment,
          sublayouts: [.fromView(self)]
        )
      )
    )

    container.addSubview(self)

    return container
  }
}
