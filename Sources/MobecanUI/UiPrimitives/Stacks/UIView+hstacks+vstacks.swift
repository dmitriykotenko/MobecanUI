//  Copyright © 2020 Mobecan. All rights reserved.


import LayoutKit
import UIKit


public extension UIView {
  
  static func hstack<Subviews: Sequence>(alignment: UIStackView.Alignment = .fill,
                                         distribution: UIStackView.Distribution? = nil,
                                         spacing: CGFloat? = nil,
                                         _ subviews: Subviews,
                                         insets: UIEdgeInsets = .zero) -> UIView where Subviews.Element == UIView {
    fastStackView(
      axis: .horizontal,
      alignment: alignment,
      distribution: distribution,
      spacing: spacing,
      subviews: subviews,
      insets: insets
    )
  }
  
  /// Returns horizontal stack
  /// with icon's vertical center visually aligned with vertical center of label's first line.
  static func hstack(distribution: UIStackView.Distribution? = nil,
                     alignment: IconTextAlignment = .xHeight,
                     spacing: CGFloat? = nil,
                     icon: UIImageView,
                     label: UILabel,
                     insets: UIEdgeInsets = .zero) -> UIView {
    
    let labelHeight = alignment.height(font: label.font)
    let iconHeight = icon.frame.height
    
    let iconBottomOffset = (labelHeight - iconHeight) / 2
    
    return .hstack(
      alignment: .firstBaseline,
      distribution: distribution,
      spacing: spacing,
      [
        icon.withInsets(.bottom(iconBottomOffset)),
        label
      ],
      insets: insets
    )
  }
  
  static func vstack<Subviews: Sequence>(alignment: UIStackView.Alignment = .fill,
                                         distribution: UIStackView.Distribution? = nil,
                                         spacing: CGFloat? = nil,
                                         _ subviews: Subviews,
                                         insets: UIEdgeInsets = .zero) -> UIView where Subviews.Element == UIView {
    fastStackView(
      axis: .vertical,
      alignment: alignment,
      distribution: distribution,
      spacing: spacing,
      subviews: subviews,
      insets: insets
    )
  }
  
  private static func stackView<Subviews: Sequence>(axis: NSLayoutConstraint.Axis,
                                                    alignment: UIStackView.Alignment = .fill,
                                                    distribution: UIStackView.Distribution? = nil,
                                                    spacing: CGFloat? = nil,
                                                    subviews: Subviews,
                                                    insets: UIEdgeInsets = .zero)
    -> UIStackView where Subviews.Element == UIView {
      
      let stack = UIStackView(arrangedSubviews: Array(subviews))

      stack.axis = axis
      stack.alignment = alignment
      distribution.map { stack.distribution = $0 }
      spacing.map { stack.spacing = $0 }
      
      stack.isLayoutMarginsRelativeArrangement = true
      stack.insetsLayoutMarginsFromSafeArea = false
      stack.layoutMargins = insets
      
      return stack
  }

  private static func fastStackView<Subviews: Sequence>(axis: NSLayoutConstraint.Axis,
                                                        alignment: UIStackView.Alignment = .fill,
                                                        distribution: UIStackView.Distribution? = nil,
                                                        spacing: CGFloat? = nil,
                                                        subviews: Subviews,
                                                        intrinsicWidth: CGFloat? = nil,
                                                        intrinsicHeight: CGFloat? = nil,
                                                        insets: UIEdgeInsets = .zero)
  -> StackView where Subviews.Element == UIView {

    let stack = StackView(
      axis: axis.asLayoutKitAxis,
      spacing: spacing ?? 0,
      distribution: distribution?.asLayoutKitDistribution ?? .fillFlexing,
      contentInsets: insets,
      childrenAlignment: alignment.asLayoutKitAlignment,
      intrinsicWidth: intrinsicWidth,
      intrinsicHeight: intrinsicHeight
    )

    stack.addArrangedSubviews(Array(subviews))

    return stack
  }
}
