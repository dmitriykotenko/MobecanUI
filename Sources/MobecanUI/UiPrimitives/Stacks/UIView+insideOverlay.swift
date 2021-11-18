//  Copyright © 2021 Mobecan. All rights reserved.


import LayoutKit
import UIKit


extension UIView {

  func insideOverlay(alignment: Alignment,
                     insets: UIEdgeInsets) -> LayoutableView {
    LayoutableView(
      layout: OverlayLayout(
        primaryLayouts: [
          InsetLayout(
            insets: insets,
            sublayout: .fromView(self)
          )
        ],
        alignment: alignment,
        flexibility: .flexible
      )
    )
  }
}
