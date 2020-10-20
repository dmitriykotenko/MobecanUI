//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


extension UIFontDescriptor.AttributeName {

  /// Undocumented "NSCTFontUIUsageAttribute" font descriptor attribute which conflicts with family name if set.
  /// See https://gist.github.com/krzyzanowskim/e986890689e4b2f980d96be07de365f8
  static let fontUiUsageAttribute =  UIFontDescriptor.AttributeName.init(rawValue: "NSCTFontUIUsageAttribute")
}
