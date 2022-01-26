// Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


public extension SwitchView {

  struct Layout {

    var minimumHeight: CGFloat?
    var spacing: CGFloat
    var switchPlacement: SwitchPlacement
    var titleInsets: UIEdgeInsets
    var overallInsets: UIEdgeInsets

    public init(minimumHeight: CGFloat? = nil,
                spacing: CGFloat,
                switchPlacement: SwitchPlacement = .center(offset: 0),
                titleInsets: UIEdgeInsets = .zero,
                overallInsets: UIEdgeInsets = .zero) {
      self.minimumHeight = minimumHeight
      self.spacing = spacing
      self.switchPlacement = switchPlacement
      self.titleInsets = titleInsets
      self.overallInsets = overallInsets
    }

    public static func spacing(_ spacing: CGFloat) -> Layout {
      .init(spacing: spacing)
    }
  }
}
