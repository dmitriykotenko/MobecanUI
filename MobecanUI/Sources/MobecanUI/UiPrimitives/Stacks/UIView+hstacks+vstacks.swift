//  Copyright © 2019 Mobecan. All rights reserved.


import SnapKit
import UIKit


public extension UIView {

  static func hstack<Subviews: Sequence>(alignment: UIStackView.Alignment = .fill,
                                         distribution: UIStackView.Distribution? = nil,
                                         padding: UIEdgeInsets = .zero,
                                         spacing: CGFloat? = nil,
                                         _ subviews: Subviews) -> UIView where Subviews.Element == UIView {
    return .zstack([
      stackView(
        axis: .horizontal,
        alignment: alignment,
        distribution: distribution,
        padding: padding,
        spacing: spacing,
        subviews: subviews
      )
    ])
  }

  /// Returns horizontal stack
  /// with icon's vertical center visually aligned with vertical center of label's first line.
  static func hstack(distribution: UIStackView.Distribution? = nil,
                     alignment: IconTextAlignment = .xHeight,
                     padding: UIEdgeInsets = .zero,
                     spacing: CGFloat? = nil,
                     icon: UIImageView,
                     label: UILabel) -> UIView {
    
    let labelHeight = alignment.height(font: label.font)
    let iconHeight = icon.frame.height
    
    let iconBottomOffset = (labelHeight - iconHeight) / 2
    
    let iconContainer = UIView.zstack(padding: .bottom(iconBottomOffset), [icon])
    
    return .hstack(
      alignment: .firstBaseline,
      distribution: distribution,
      padding: padding,
      spacing: spacing,
      [iconContainer, label]
    )
  }

  static func vstack<Subviews: Sequence>(alignment: UIStackView.Alignment = .fill,
                                         distribution: UIStackView.Distribution? = nil,
                                         padding: UIEdgeInsets = .zero,
                                         spacing: CGFloat? = nil,
                                         _ subviews: Subviews) -> UIView where Subviews.Element == UIView {
    return
      .zstack([
        stackView(
          axis: .vertical,
          alignment: alignment,
          distribution: distribution,
          padding: padding,
          spacing: spacing,
          subviews: subviews
        )
    ])
  }

  private static func stackView<Subviews: Sequence>(axis: NSLayoutConstraint.Axis,
                                                    alignment: UIStackView.Alignment = .fill,
                                                    distribution: UIStackView.Distribution? = nil,
                                                    padding: UIEdgeInsets = .zero,
                                                    spacing: CGFloat? = nil,
                                                    subviews: Subviews)
    -> UIStackView where Subviews.Element == UIView {
      
    let stack = UIStackView(arrangedSubviews: Array(subviews))
    
    stack.axis = axis
    stack.alignment = alignment
    distribution.map { stack.distribution = $0 }
    spacing.map { stack.spacing = $0 }
    
    stack.isLayoutMarginsRelativeArrangement = true
    stack.insetsLayoutMarginsFromSafeArea = false
    stack.layoutMargins = padding
    
    return stack
  }
}
