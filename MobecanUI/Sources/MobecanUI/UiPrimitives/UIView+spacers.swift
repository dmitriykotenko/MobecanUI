//  Copyright © 2019 Mobecan. All rights reserved.

import SnapKit
import UIKit


public extension UIView {
  
  static func zeroHeightView(layoutPriority: ConstraintPriority = .required) -> UIView {
    return UIView().height(0, priority: layoutPriority)
  }

  static func spacer(width: CGFloat? = nil,
                     height: CGFloat? = nil,
                     layoutPriority: ConstraintPriority = .required) -> UIView {
    let spacer = UIView()
    
    width.map { _ = spacer.width($0, priority: layoutPriority) }
    height.map { _ = spacer.height($0, priority: layoutPriority) }
    
    return spacer
  }

  static func stretchableSpacer(minimumWidth: CGFloat? = nil,
                                minimumHeight: CGFloat? = nil) -> UIView {
    let spacer = UIView()

    spacer.snp.makeConstraints {
      $0.width.height.equalTo(0).priority(.minimum)
    }
    
    minimumWidth.map { _ = spacer.minimumWidth($0) }
    minimumHeight.map { _ = spacer.minimumHeight($0) }
    
    return spacer
  }

  static func rxHorizontalSpacer(_ targetView: UIView,
                                 insets: UIEdgeInsets = .zero) -> UIView {
    return ReactiveSpacerView(
      targetView: targetView,
      axis: [.horizontal],
      insets: insets
    )
  }
  
  static func rxVerticalSpacer(_ targetView: UIView,
                               insets: UIEdgeInsets = .zero) -> UIView {
    return ReactiveSpacerView(
      targetView: targetView,
      axis: [.vertical],
      insets: insets
    )
  }
  
  static func rxSpacer(_ targetView: UIView,
                       insets: UIEdgeInsets = .zero) -> UIView {
    return ReactiveSpacerView(
      targetView: targetView,
      axis: [.horizontal, .vertical],
      insets: insets
    )
  }
}
