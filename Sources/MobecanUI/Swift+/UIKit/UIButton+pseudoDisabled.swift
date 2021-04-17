//  Copyright © 2021 Mobecan. All rights reserved.

import UIKit


public extension UIButton {

  /// Quick-and-dirty emulation of tappable version of UIButton's '.disabled' state.
  ///
  /// Button remains tappable, but may look different from its '.normal' state.
  var isPseudoDisabled: Bool {
    get { isSelected }
    set { isSelected = newValue }
  }
}


public extension UIControl.State {

  /// '.pseudoDisabled' is exactly the same as '.selected' state.
  ///
  /// It is useful for quick-and-dirty emulation of tappable version of UIButton's '.disabled' state.
  ///
  /// '.pseudoDisabled' button remains tappable, but may look different from its '.normal' state.
  static let pseudoDisabled = selected
}
