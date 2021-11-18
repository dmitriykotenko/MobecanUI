//  Copyright © 2020 Mobecan. All rights reserved.


import LayoutKit
import UIKit


public extension NSLayoutConstraint.Axis {

  var asLayoutKitAxis: LayoutKit.Axis {
    switch self {
    case .horizontal:
      return .horizontal
    case .vertical:
      return .vertical
    @unknown default:
      fatalError("NSLayoutConstraint.Axis \"\(self)\" is not supported")
    }
  }
}


public extension UIStackView.Alignment {

  var asLayoutKitAlignment: LayoutKit.Alignment {
    switch self {
    case .leading:
      return .fillLeading
    case .trailing:
      return .fillTrailing
    case .top:
      return .topFill
    case .bottom:
      return .bottomFill
    case .center:
      return .center
    case .fill:
      return .fill
    case .firstBaseline:
      return .topFill
    case .lastBaseline:
      return .bottomFill
    @unknown default:
      fatalError("UIStackView.Alignment \"\(self)\" is not supported")
    }
  }
}


public extension UIStackView.Distribution {

  var asLayoutKitDistribution: LayoutKit.StackLayoutDistribution {
    switch self {
    case .fill:
      return .fillFlexing
    case .equalCentering:
      return .fillEqualSize
    case .equalSpacing:
      return .fillEqualSpacing
    case .fillEqually:
      return .fillEqualSize
    case .fillProportionally:
      return .fillFlexing
    @unknown default:
      fatalError("UIStackView.Distribution \"\(self)\" is not supported")
    }
  }
}
