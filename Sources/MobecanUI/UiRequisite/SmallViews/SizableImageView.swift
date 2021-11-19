//  Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import UIKit


open class SizableImageView: UIImageView {

  open var fixedWidth: CGFloat?
  open var fixedHeight: CGFloat?

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    var result = super.sizeThatFits(size)

    fixedWidth.map { result.width = $0 }
    fixedHeight.map { result.height = $0 }

    return result
  }

  @discardableResult
  func fixedWidth(_ width: CGFloat?) -> Self {
    self.fixedWidth = width
    return self
  }

  @discardableResult
  func fixedHeight(_ height: CGFloat?) -> Self {
    self.fixedHeight = height
    return self
  }
}
