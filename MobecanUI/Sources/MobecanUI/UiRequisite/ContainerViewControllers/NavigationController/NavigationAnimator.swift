//  Copyright © 2020 Mobecan. All rights reserved.

import SwiftDateTime
import UIKit


class NavigationAnimator {
  
  enum Animation {
    case none
    case push
    case pop
  }
  
  private struct Frames {
    let start: AnimationFrame
    let end: AnimationFrame
  }
  
  private struct AnimationFrame {
    let oldScreenOffset: CGFloat
    let newScreenOffset: CGFloat
    
    static var zero = AnimationFrame(oldScreenOffset: 0, newScreenOffset: 0)
  }
  
  private weak var navigationView: UIView?
  private let animationDuration: Duration
  
  init(navigationView: UIView,
       animationDuration: Duration) {
    self.navigationView = navigationView
    self.animationDuration = animationDuration
  }
  
  func performAnimation(_ animation: Animation,
                        from oldViewController: UIViewController?,
                        to newViewController: UIViewController?,
                        completion: @escaping () -> Void) {
    switch animation {
    case .none:
      completion()
    default:
      animateFrames(
        frames(animation: animation),
        oldViewController: oldViewController,
        newViewController: newViewController,
        duration: animationDuration,
        completion: completion
      )
    }
  }
  
  private func animateFrames(_ frames: Frames,
                             oldViewController: UIViewController?,
                             newViewController: UIViewController?,
                             duration: Duration,
                             completion: @escaping () -> Void) {
    let start = frames.start
    let end = frames.end
    
    oldViewController?.view.transform = .init(translationX: start.oldScreenOffset, y: 0)
    newViewController?.view.transform = .init(translationX: start.newScreenOffset, y: 0)
    
    let animator = UIViewPropertyAnimator(
      duration: duration.toTimeInterval,
      curve: .easeInOut,
      animations: {
        oldViewController?.view.transform = .init(translationX: end.oldScreenOffset, y: 0)
        newViewController?.view.transform = .init(translationX: end.newScreenOffset, y: 0)
      }
    )
    
    animator.addCompletion { position in
      if position == .end {
        completion()
      } else {
        print("Wrong animator position: \(position).")
      }
    }
    
    animator.startAnimation()
  }
  
  private func frames(animation: Animation) -> Frames {
    guard let navigationView = navigationView else { return .init(start: .zero, end: .zero) }
    
    let screenWidth = navigationView.bounds.size.width
    
    switch animation {
    case .none:
      return Frames(start: .zero, end: .zero)

    case .push:
      return Frames(
        start: .init(oldScreenOffset: 0, newScreenOffset: screenWidth),
        end: .init(oldScreenOffset: -screenWidth, newScreenOffset: 0)
      )
    case .pop:
      return Frames(
        start: .init(oldScreenOffset: 0, newScreenOffset: -screenWidth),
        end: .init(oldScreenOffset: screenWidth, newScreenOffset: 0)
      )
    }
  }
}
