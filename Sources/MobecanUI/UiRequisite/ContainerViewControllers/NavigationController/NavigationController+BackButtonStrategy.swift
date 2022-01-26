// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension NavigationController {
  
  enum BackButtonStrategy {
    
    /// No back button if there is no view controllers in stack.
    /// `Arrow` button otherwise.
    case backOrNone
    
    /// No button if there are no view controllers in stack.
    /// `Cross` button if there is single view controller in stack.
    /// `Arrow` button otherwise.
    case backOrCloseOrNone
    
    /// `Arrow` button always (even if there are no view controllers in stack).
    case back
    
    public func backButtonStyle(viewControllers: [UIViewController]) -> NavigationButtonStyle {
      switch self {
      case .backOrNone:
        return viewControllers.count <= 1 ? .none : .back
      case .backOrCloseOrNone:
        return viewControllers.isEmpty ? .none : viewControllers.count == 1 ? .close : .back
      case .back:
        return .back
      }
    }
  }
}
