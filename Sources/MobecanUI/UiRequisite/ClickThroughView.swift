// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


/// View that is transparent for gestures.
///
/// If another view is placed behind `ClickThroughView`,
/// the user can tap or scroll this another view.
open class ClickThroughView: UIView {

  override open func hitTest(_ point: CGPoint,
                             with event: UIEvent?) -> UIView? {
    let hit = super.hitTest(point, with: event)
    
    switch hit {
    case self: return nil
    default: return hit
    }
  }
}
