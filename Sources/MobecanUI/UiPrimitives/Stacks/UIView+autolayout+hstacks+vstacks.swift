// Copyright © 2020 Mobecan. All rights reserved.


import LayoutKit
import UIKit


public extension UIView {
  
  static func autolayoutHstack<Subviews: Sequence>(
    alignment: UIStackView.Alignment = .fill,
    distribution: UIStackView.Distribution? = nil,
    spacing: CGFloat? = nil,
    _ subviews: Subviews,
    insets: UIEdgeInsets = .zero
  ) -> UIView where Subviews.Element == UIView {
    stackView(
      axis: .horizontal,
      alignment: alignment,
      distribution: distribution,
      spacing: spacing,
      subviews: subviews,
      insets: insets
    )
  }
  
  /// Горизонтальный стэк,
  /// у которого `bulletView` вертикально выравнен по первой строке текста лэйбла.
  static func autolayoutHstack(distribution: UIStackView.Distribution? = nil,
                               alignment: BulletToTextAlignment = .xHeight,
                               spacing: CGFloat? = nil,
                               bulletView: UIView,
                               label: UILabel,
                               insets: UIEdgeInsets = .zero) -> UIView {
    
    let labelHeight = alignment.height(font: label.font)
    let bulletHeight = bulletView.frame.height

    let bulletBottomOffset = (labelHeight - bulletHeight) / 2

    return .autolayoutHstack(
      alignment: .firstBaseline,
      distribution: distribution,
      spacing: spacing,
      [
        bulletView.withInsets(.bottom(bulletBottomOffset)),
        label
      ],
      insets: insets
    )
  }
  
  static func autolayoutVstack<Subviews: Sequence>(
    alignment: UIStackView.Alignment = .fill,
    distribution: UIStackView.Distribution? = nil,
    spacing: CGFloat? = nil,
    _ subviews: Subviews,
    insets: UIEdgeInsets = .zero
  ) -> UIView where Subviews.Element == UIView {
    stackView(
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
}
