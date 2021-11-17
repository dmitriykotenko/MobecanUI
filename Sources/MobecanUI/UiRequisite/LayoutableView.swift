//  Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import UIKit


open class LayoutableView: UIView {

  open var isClickThroughEnabled: Bool = false
  open var layout: Layout

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init() {
    self.layout = EmptyLayout()

    super.init(frame: .zero)

    translatesAutoresizingMaskIntoConstraints = false
  }

  public convenience init(layout: Layout) {
    self.init()
    self.layout = layout
  }

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    layout.measurement(within: size).size
  }

  override open func layoutSubviews() {
    layout.measurement(within: bounds.size).arrangement(within: bounds).makeViews(in: self)
  }

  override open func hitTest(_ point: CGPoint,
                             with event: UIEvent?) -> UIView? {
    let hit = super.hitTest(point, with: event)

    switch hit {
    case self where isClickThroughEnabled: return nil
    default: return hit
    }
  }

  @discardableResult
  open func isClickThroughEnabled(_ isClickThroughEnabled: Bool) -> Self {
    self.isClickThroughEnabled = isClickThroughEnabled
    return self
  }
}


private class EmptyLayout: Layout {

  func measurement(within maxSize: CGSize) -> LayoutMeasurement {
    .init(
      layout: self,
      size: maxSize,
      maxSize: maxSize,
      sublayouts: []
    )
  }

  func arrangement(within rect: CGRect,
                   measurement: LayoutMeasurement) -> LayoutArrangement {
    LayoutArrangement(
      layout: self,
      frame: rect,
      sublayouts: []
    )
  }

  let needsView: Bool = false

  func makeView() -> UIView {
    UIView().translatesAutoresizingMaskIntoConstraints(false)
  }

  func configure(baseTypeView: UIView) {}

  let flexibility: Flexibility = .flexible

  let viewReuseId: String? = nil
}