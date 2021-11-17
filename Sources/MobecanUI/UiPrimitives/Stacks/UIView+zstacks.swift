//  Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import UIKit


public extension UIView {

  static func zstack(_ subviews: [UIView],
                     insets: UIEdgeInsets = .zero) -> ClickThroughView {
    FastZstack(subviews, insets: insets)
  }

  static func safeAreaZstack(_ subviews: [UIView],
                             insets: UIEdgeInsets = .zero) -> ClickThroughView {
    FastSafeAreaZstack(subviews, insets: insets)
  }
}


private class FastZstack: ClickThroughView {

  private let insets: UIEdgeInsets

  required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  init(_ subviews: [UIView], insets: UIEdgeInsets) {
    self.insets = insets

    super.init(frame: .zero)

    translatesAutoresizingMaskIntoConstraints = false

    subviews.forEach(addSubview)
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let sizeWithoutInsets = size.insetBy(insets)
    
    return
      subviews.map { $0.sizeThatFits(sizeWithoutInsets) }.first
      ?? sizeWithoutInsets
  }

  override func layoutSubviews() {
    subviews.forEach { $0.frame = self.bounds.inset(by: insets) }
  }
}


private class FastSafeAreaZstack: ClickThroughView {

  private let insets: UIEdgeInsets

  required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  init(_ subviews: [UIView], insets: UIEdgeInsets) {
    self.insets = insets

    super.init(frame: .zero)

    translatesAutoresizingMaskIntoConstraints = false

    subviews.forEach(addSubview)
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let maximumBounds = CGRect(origin: .zero, size: size)
    let safeAreaFrame = safeAreaLayoutGuide.layoutFrame
    let safeAreaInsets = maximumBounds.insets(of: safeAreaFrame)

    let sizeWithoutSafeArea = size.insetBy(safeAreaInsets)
    let sizeWithoutInsets = sizeWithoutSafeArea.insetBy(insets)

    return
      subviews.map { $0.sizeThatFits(sizeWithoutInsets) }.first
      ?? sizeWithoutInsets
  }

  override func layoutSubviews() {
    let safeAreaFrame = safeAreaLayoutGuide.layoutFrame
    let childFrame = safeAreaFrame.inset(by: insets)

    subviews.forEach { $0.frame = childFrame }
  }
}


private extension CGRect {

  func insets(of innerRect: CGRect) -> UIEdgeInsets {
    .init(
      top: innerRect.minY - minY,
      left: innerRect.minX - minX,
      bottom: maxY - innerRect.maxY,
      right: maxX - innerRect.maxX
    )
  }
}
