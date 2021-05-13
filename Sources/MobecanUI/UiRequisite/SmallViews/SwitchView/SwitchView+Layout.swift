//  Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


public extension SwitchView {

  struct Layout {

    var spacing: CGFloat
    var switchPlacement: SwitchPlacement
    var contentHuggingPriority: ConstraintPriority
    var titleInsets: UIEdgeInsets
    var overallInsets: UIEdgeInsets

    public init(spacing: CGFloat,
                switchPlacement: SwitchPlacement = .center(offset: 0),
                contentHuggintPriority: ConstraintPriority = .required,
                titleInsets: UIEdgeInsets = .zero,
                overallInsets: UIEdgeInsets = .zero) {
      self.spacing = spacing
      self.switchPlacement = switchPlacement
      self.contentHuggingPriority = contentHuggintPriority
      self.titleInsets = titleInsets
      self.overallInsets = overallInsets
    }

    public static func spacing(_ spacing: CGFloat) -> Layout {
      .init(spacing: spacing)
    }
  }
}
