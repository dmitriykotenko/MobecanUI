//  Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import UIKit


public extension UIView {

  func inheritContentHuggingPriority(from anotherView: UIView) {
    inheritContentHuggingPriority(from: anotherView, axis: .horizontal)
    inheritContentHuggingPriority(from: anotherView, axis: .vertical)
  }

  func inheritContentHuggingPriority(from anotherView: UIView,
                                     axis: NSLayoutConstraint.Axis) {
    setContentHuggingPriority(
      anotherView.contentHuggingPriority(for: axis),
      for: axis
    )
  }

  func inheritContentCompressionResistancePriority(from anotherView: UIView) {
    inheritContentCompressionResistancePriority(from: anotherView, axis: .horizontal)
    inheritContentCompressionResistancePriority(from: anotherView, axis: .vertical)
  }

  func inheritContentCompressionResistancePriority(from anotherView: UIView,
                                                   axis: NSLayoutConstraint.Axis) {
    setContentCompressionResistancePriority(
      anotherView.contentCompressionResistancePriority(for: axis),
      for: axis
    )
  }
}
