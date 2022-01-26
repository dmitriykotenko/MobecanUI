// Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import UIKit


open class SizableTextView: UITextView, SizableView {

  open var isLayoutInvalidationEnabled: Bool = true
  open var sizer = ViewSizer()

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    sizer.apply(to: super.sizeThatFits(size))
  }

  override open var text: String! { didSet { invalidateLayoutIfNecessary() } }
  override open var attributedText: NSAttributedString! { didSet { invalidateLayoutIfNecessary() } }
  override open var font: UIFont? { didSet { invalidateLayoutIfNecessary() } }

  private func invalidateLayoutIfNecessary() {
    if isLayoutInvalidationEnabled {
      superview?.subviewNeedsToLayout(subview: self)
    }
  }

  @discardableResult
  open func enableLayoutInvalidation() -> Self {
    isLayoutInvalidationEnabled = true
    return self
  }

  @discardableResult
  open func disableLayoutInvalidation() -> Self {
    isLayoutInvalidationEnabled = false
    return self
  }
}
