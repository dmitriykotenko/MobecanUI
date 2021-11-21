//  Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import UIKit


public extension Layout where Self == BoilerplateLayout {

  static func fromView(_ view: UIView,
                       alignment: Alignment = .fill) -> BoilerplateLayout {
    BoilerplateLayout(view, alignment: alignment)
  }
}


public extension UIView {

  var asLayout: Layout { .fromView(self) }

  func withAlignment(_ alignment: Alignment) -> Layout {
    .fromView(self, alignment: alignment)
  }
}
