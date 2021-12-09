//  Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import UIKit


open class LayoutableControl: UIControl {

  open var isClickThroughEnabled: Bool = false

  open var layout: Layout {
    didSet {
      removeAllSubviews()
      updateContentHuggingPriority()
      if window != nil { setNeedsLayoutAndPropagate() }
    }
  }

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init() {
    self.layout = EmptyLayout()

    super.init(frame: .zero)
  }

  public convenience init(layout: Layout) {
    self.init()
    self.layout = layout
    updateContentHuggingPriority()
  }

  private func updateContentHuggingPriority() {
    setContentHuggingPriority(.from(layout.flexibility.horizontal), for: .horizontal)
    setContentHuggingPriority(.from(layout.flexibility.vertical), for: .vertical)
  }

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    return layout.measurement(within: size).size
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


private extension UILayoutPriority {

  static func from(_ flex: Flexibility.Flex) -> UILayoutPriority {
    flex.map { UILayoutPriority(rawValue: Float(-$0).clipped(inside: 0...999)) }
    ?? .required
  }
}
