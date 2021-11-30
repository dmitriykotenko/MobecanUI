//  Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import UIKit


public extension Layout where Self == BoilerplateLayout {

  static func fromView(_ view: UIView,
                       alignment: Alignment = .fill) -> BoilerplateLayout {
    BoilerplateLayout(view, alignment: alignment)
  }
}


public extension Layout where Self == InsetLayout<UIView> {

  static func fromSingleSubview(_ subview: UIView,
                                alignment: Alignment = .fill,
                                insets: UIEdgeInsets = .zero) -> Layout {
    .fromView(subview, alignment: alignment)
      .withInsets(insets)
  }
}


public extension UIView {

  var asLayout: Layout { .fromView(self) }

  func withAlignment(_ alignment: Alignment) -> Layout {
    .fromView(self, alignment: alignment)
  }
}
