// Copyright © 2022 Mobecan. All rights reserved.

import LayoutKit
import RxSwift
import UIKit


/// UIScrollView, совместимый с LayoutKit.
open class SizableScrollView: UIScrollView, SizableView {

  open var sizer = ViewSizer()

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    sizer.sizeThatFits(
      size,
      nativeSizing: super.sizeThatFits
    )
  }

  required public init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public convenience init() { self.init(frame: .zero) }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    withStretchableSize()
  }
}
