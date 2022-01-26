// Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import SwiftDateTime
import UIKit


public protocol SizableView: UIView {

  var sizer: ViewSizer { get }
}


public extension SizableView {

  @discardableResult
  func fixWidth(_ width: CGFloat?) -> Self {
    sizer.minimumWidth = width
    sizer.maximumWidth = width
    return self
  }

  @discardableResult
  func fixHeight(_ height: CGFloat?) -> Self {
    sizer.minimumHeight = height
    sizer.maximumHeight = height
    return self
  }

  @discardableResult
  func fixSize(_ size: CGSize?) -> Self {
    self.fixWidth(size?.width).fixHeight(size?.height)
  }

  @discardableResult
  func fixMinimumWidth(_ width: CGFloat?) -> Self {
    sizer.minimumWidth = width
    return self
  }

  @discardableResult
  func fixMinimumHeight(_ height: CGFloat?) -> Self {
    sizer.minimumHeight = height
    return self
  }

  @discardableResult
  func fixMinimumSize(_ size: CGSize?) -> Self {
    self
      .fixMinimumWidth(size?.width)
      .fixMinimumHeight(size?.height)
  }

  @discardableResult
  func fixMaximumWidth(_ width: CGFloat?) -> Self {
    sizer.minimumWidth = width
    return self
  }

  @discardableResult
  func fixMaximumHeight(_ height: CGFloat?) -> Self {
    sizer.minimumHeight = height
    return self
  }

  @discardableResult
  func fixMaximumSize(_ size: CGSize?) -> Self {
    self
      .fixMaximumWidth(size?.width)
      .fixMaximumHeight(size?.height)
  }
}
