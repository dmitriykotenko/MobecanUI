//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public extension EndOfScreenView.Layout {

  static func vertical(spacing: CGFloat,
                       insets: UIEdgeInsets,
                       respectSafeArea: Bool = true) -> EndOfScreenView.Layout {
    .init { subviews in
      let contentView = UIView.vstack(
        spacing: spacing,
        [subviews.hintLabel] +
          subviews.additionalViews +
          [subviews.errorLabel] +
          [subviews.button],
        insets: insets
      )

      let containerView: UIView =
        respectSafeArea ? .safeAreaZstack([contentView]) : contentView

      return (contentView: contentView, containerView: containerView)
    }
  }
}
