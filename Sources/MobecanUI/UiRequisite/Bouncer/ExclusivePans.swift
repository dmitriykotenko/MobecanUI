//  Copyright © 2020 Mobecan. All rights reserved.


import RxCocoa
import RxGesture
import RxSwift
import UIKit


public extension Reactive where Base: UIView {
  
  func exclusivePan(axis: NSLayoutConstraint.Axis,
                    started startPosition: PanStartPosition? = nil) -> PanControlEvent {
    let view = self.base
    
    return panGesture { _, delegate in
      delegate.beginPolicy = .custom {
        guard let pan = $0 as? UIPanGestureRecognizer else { return false }
        
        // Track only pans started above, around or below anotherView.
        let startPositionIsValid = startPosition?.isValid(for: pan) ?? true
        
        // Track only vertical pans.
        let startVelocity = pan.velocity(in: view)
        
        let startVelocityIsValid = (axis == .horizontal) ?
          abs(startVelocity.y) <= abs(startVelocity.x) :
          abs(startVelocity.y) > abs(startVelocity.x)
        
        return startPositionIsValid && startVelocityIsValid
      }
      
      // Disable other views' pan gestures (e. g., vertical scrolling in parent table view).
      delegate.selfFailureRequirementPolicy = .custom { _, otherRecognizer in
        otherRecognizer is UIPanGestureRecognizer
      }
    }
  }
  
  func exclusiveHorizontalPan(started startPosition: PanStartPosition? = nil) -> PanControlEvent {
    exclusivePan(axis: .horizontal, started: startPosition)
  }
  
  func exclusiveVerticalPan(started startPosition: PanStartPosition? = nil) -> PanControlEvent {
    exclusivePan(axis: .vertical, started: startPosition)
  }
}
