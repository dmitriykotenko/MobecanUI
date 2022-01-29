// Copyright © 2020 Mobecan. All rights reserved.


import LayoutKit
import UIKit


public extension NSLayoutConstraint.Axis {

  /// Converts NSLayoutConstraint.Axis to LayoutKit.Axis.
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

  /// Converts UIStackView.Alignment to LayoutKit.Alignment.
  ///
  /// UIStackView.Alignment.top is actually an alias for UIStackView.Alignment.leading.
  ///
  /// UIStackView.Alignment.bottom is actually an alias for UIStackView.Alignment.trailing.
  ///
  /// So, to correctly convert UIStackView.Alignment to LayoutKit.Alignment,
  /// additional information about axis is needed.
  func asLayoutKitAlignment(axis: NSLayoutConstraint.Axis) -> LayoutKit.Alignment {
    switch axis {
    case .horizontal:
      switch self {
      case .top:
        return .topFill
      case .bottom:
        return .bottomFill
      case .center:
        return .centerFill
      case .fill:
        return .fill
      case .firstBaseline:
        return .topFill
      case .lastBaseline:
        return .bottomFill
      case .leading, .trailing:
        fatalError("UIStackView.Alignment \"\(self)\" is not supported")
      @unknown default:
        fatalError("UIStackView.Alignment \"\(self)\" is not supported for \(axis) axis")
      }

    case .vertical:
      switch self {
      case .leading:
        return .fillLeading
      case .trailing:
        return .fillTrailing
      case .center:
        return .fillCenter
      case .fill:
        return .fill
      case .firstBaseline, .lastBaseline:
        fatalError("UIStackView.Alignment \"\(self)\" is not supported for \(axis) axis")
      @unknown default:
        fatalError("UIStackView.Alignment \"\(self)\" is not supported")
      }
    @unknown default:
      fatalError("NSLayoutConstraint.Axis \"\(axis)\" is not supported")
    }
  }
}


public extension UIStackView.Distribution {

  /// Converts UIStackView.Distribution to LayoutKit.StackLayoutDistribution.
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
