// Copyright © 2022 Mobecan. All rights reserved.

import LayoutKit
import RxSwift
import UIKit


/// UITableView, совместимый с LayoutKit.
open class SizableTableView: UITableView, SizableView {

  open var sizer = ViewSizer()

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    sizer.sizeThatFits(
      size,
      nativeSizing: super.sizeThatFits
    )
  }

  required public init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public convenience init() { self.init(frame: .zero) }
  public convenience init(frame: CGRect) { self.init(frame: frame, style: .plain) }

  override public init(frame: CGRect,
                       style: UITableView.Style) {
    super.init(frame: frame, style: .plain)
    withStretchableSize()
  }
}
