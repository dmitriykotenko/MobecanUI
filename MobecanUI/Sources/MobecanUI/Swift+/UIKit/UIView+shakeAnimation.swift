//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIView {
  
  func shake(duration: TimeInterval) {
    UIView.animateKeyframes(
      withDuration: duration,
      delay: 0,
      options: [.calculationModeCubic],
      animations: { [weak self] in
        self?.addKeyframe(start: 0, duration: 0.1, xOffset: -10)
        self?.addKeyframe(start: 0.1, duration: 0.1, xOffset: 10)
        self?.addKeyframe(start: 0.2, duration: 0.1, xOffset: -30)
        self?.addKeyframe(start: 0.3, duration: 0.1, xOffset: 30)
        self?.addKeyframe(start: 0.4, duration: 0.1, xOffset: -30)
        self?.addKeyframe(start: 0.5, duration: 0.1, xOffset: 30)
        self?.addKeyframe(start: 0.6, duration: 0.1, xOffset: -30)
        self?.addKeyframe(start: 0.7, duration: 0.1, xOffset: 10)
        self?.addKeyframe(start: 0.8, duration: 0.1, xOffset: -10)
        self?.addKeyframe(start: 0.9, duration: 0.1, xOffset: 0)
      },
      completion: { [weak self] finished in
        if finished { self?.transform = .identity }
      }
    )
  }
  
  private func addKeyframe(start: Double, duration: Double, xOffset: CGFloat) {
    addKeyframe(
      start: start,
      duration: duration,
      property: \.transform,
      value: CGAffineTransform(translationX: xOffset, y: 0)
    )
  }
}
