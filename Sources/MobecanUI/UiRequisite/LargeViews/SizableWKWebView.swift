// Copyright © 2022 Mobecan. All rights reserved.

import LayoutKit
import RxSwift
import UIKit
import WebKit


/// WKWebView, совместимый с LayoutKit.
open class SizableWKWebView: WKWebView, SizableView {

  open var sizer = ViewSizer()

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    sizer.sizeThatFits(
      size,
      nativeSizing: super.sizeThatFits
    )
  }

  required public init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public convenience init() { self.init(frame: .zero) }
  public convenience init(frame: CGRect) { self.init(frame: .zero, configuration: .init()) }

  override public init(frame: CGRect,
                       configuration: WKWebViewConfiguration) {
    super.init(frame: frame, configuration: configuration)
    withStretchableSize()
  }
}
