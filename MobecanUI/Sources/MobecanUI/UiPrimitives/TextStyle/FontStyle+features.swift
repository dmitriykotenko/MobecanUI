//  Copyright © 2019 Mobecan. All rights reserved.

import UIKit


public extension FontStyle {
  
  static let monospacedDigits: FontFeature = [
    .featureIdentifier: kNumberSpacingType,
    .typeIdentifier: kMonospacedNumbersSelector
  ]
  
  static let oldStyleDigits: FontFeature = [
    .featureIdentifier: kNumberCaseType,
    .typeIdentifier: kLowerCaseNumbersSelector
  ]
}
