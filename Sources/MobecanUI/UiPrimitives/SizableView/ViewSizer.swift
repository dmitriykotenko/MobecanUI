//  Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import SwiftDateTime
import UIKit


open class ViewSizer {

  open var minimumWidth: CGFloat?
  open var minimumHeight: CGFloat?

  open var maximumWidth: CGFloat?
  open var maximumHeight: CGFloat?

  public init() {}

  open func apply(to size: CGSize) -> CGSize {
    var result = size

    minimumWidth.map { result.width = max(result.width, $0) }
    minimumHeight.map { result.height = max(result.height, $0) }

    maximumWidth.map { result.width = min(result.width, $0) }
    maximumHeight.map { result.height = min(result.height, $0) }

    return result
  }
}
