//  Copyright © 2020 Mobecan. All rights reserved.

import SwiftDateTime
import UIKit


public extension UIView {
    
  func showAnimating(duration: Duration = .systemAnimation) {
    guard isHidden else { return }
    
    alpha = 0
    isHidden = false
    
    UIView.animate(
      withDuration: duration.toTimeInterval,
      delay: 0,
      options: [.beginFromCurrentState, .curveEaseOut],
      animations: { [weak self] in self?.alpha = 1 }
    )
  }
  
  func hideAnimating(duration: Duration = .systemAnimation) {
    guard !isHidden else { return }
    
    UIView.animate(
      withDuration: duration.toTimeInterval,
      delay: 0,
      options: [.beginFromCurrentState, .curveEaseOut],
      animations: { [weak self] in self?.alpha = 0 },
      completion: { [weak self] finished in
        if finished { self?.isHidden = true }
      }
    )
  }
}


public extension Duration {
  
  static var systemAnimation: Duration { 250.milliseconds }
}
