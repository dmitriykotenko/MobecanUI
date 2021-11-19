//  Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import SnapKit
import UIKit
import SwiftUI


public extension UIView {

  static func autolayoutZeroHeightView(layoutPriority: ConstraintPriority = .required) -> UIView {
    let zeroHeightView = UIView()

    zeroHeightView.disableTemporaryConstraints()

    return zeroHeightView.autolayoutHeight(0, priority: layoutPriority)
  }

  static func autolayoutSpacer(width: CGFloat? = nil,
                               height: CGFloat? = nil,
                               layoutPriority: ConstraintPriority = .required) -> UIView {
    let spacer = UIView()

    spacer.disableTemporaryConstraints()

    width.map { _ = spacer.autolayoutWidth($0, priority: layoutPriority) }
    height.map { _ = spacer.autolayoutHeight($0, priority: layoutPriority) }

    return spacer
  }

  static func autolayoutStretchableSpacer(minimumWidth: CGFloat? = nil,
                                          minimumHeight: CGFloat? = nil) -> UIView {
    let spacer = UIView()

    spacer.disableTemporaryConstraints()

    spacer.snp.makeConstraints {
      $0.width.height.equalTo(0).priority(.minimum)
    }

    minimumWidth.map { _ = spacer.autolayoutMinimumWidth($0) }
    minimumHeight.map { _ = spacer.autolayoutMinimumHeight($0) }

    return spacer
  }
}
