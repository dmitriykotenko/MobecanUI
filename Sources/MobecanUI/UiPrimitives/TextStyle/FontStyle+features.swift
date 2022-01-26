// Copyright © 2020 Mobecan. All rights reserved.

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

  /// Preferred way to display all letters as small caps.
  ///
  /// This option is more reliable than `.caseAgnosticSmallCaps`.
  static let smallCaps: [FontFeature] = [lowercaseSmallCaps, uppercaseSmallCaps, caseAgnosticSmallCaps]

  /// All letters will be displayed as small caps.
  ///
  /// The feature doesn't work for system "SF" font, use `.smallCaps` instead.
  static let caseAgnosticSmallCaps: FontFeature = [
    .featureIdentifier: kLetterCaseType,
    .typeIdentifier: kSmallCapsSelector
  ]
  
  /// All lowercase letters will be displayed as small caps.
  static let lowercaseSmallCaps: FontFeature = [
    .featureIdentifier: kLowerCaseType,
    .typeIdentifier: kLowerCaseSmallCapsSelector
  ]
  
  /// All uppercase letters will be displayed as small caps.
  static let uppercaseSmallCaps: FontFeature = [
    .featureIdentifier: kUpperCaseType,
    .typeIdentifier: kUpperCaseSmallCapsSelector
  ]
}
