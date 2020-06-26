//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


extension UIView {
  
  var longTermBottomY: CGFloat? {
    guard
      let parentView = parentViewController?.view,
      let parentWindow = parentView.window
      else { return nil }

    let guarantee = parentViewController as? BottomInsetGuarantee
    let guaranteedBottomInset = guarantee?.guaranteedBottomInset(for: self)
    
    let selfFrame = parentWindow.convert(frame, from: superview)
    let parentViewFrame = parentWindow.convert(parentView.frame, from: parentView.superview)
    let currentBottomInset = parentViewFrame.maxY - selfFrame.maxY
    
    return
      parentViewController?.longTermBottomY.map { $0 - (guaranteedBottomInset ?? currentBottomInset) }
      ?? selfFrame.maxY
  }
}


private extension UIResponder {
    
  var parentViewController: UIViewController? {
    return (next as? UIViewController) ?? next?.parentViewController
  }
}


private extension UIViewController {
  
  var longTermBottomY: CGFloat? {
    let maybeParent = view.superview?.parentViewController
    let maybeWindow = view.window
    
    switch (maybeParent, maybeWindow) {
    case (nil, nil):
      return nil
    case (nil, let window?):
      return window
        .convert(view.frame, from: view.superview)
        .maxY
    case (let parent?, let window?) where parent.view.window == window:
      let parentView = parent.view
    
      let guarantee = parent as? BottomInsetGuarantee
      let guaranteedBottomInset = guarantee?.guaranteedBottomInset(for: view)
    
      let viewFrame = window.convert(view.frame, from: view.superview)
      let parentViewFrame = parentView.map { window.convert($0.frame, from: $0.superview) }
      let currentBottomInset = parentViewFrame.map { $0.maxY - viewFrame.maxY } ?? 0
    
      return
        parent.longTermBottomY.map { $0 - (guaranteedBottomInset ?? currentBottomInset) }
          ?? view.window.map { _ in view.frame.maxY }
    case (let parent?, let window?):
      fatalError(
        "self.window is not equal to parent view controller's window.\n" +
        "self = \(self), parent view controller = \(parent)\n" +
        "self.window = \(window), parent view controller's  window = \(String(describing: parent.view.window))"
      )
    case (let parent?, nil):
      fatalError(
        "self.window is nil, but parent view controller is not nil.\n" +
        "self = \(self), parent view controller = \(parent)\n"
      )
    }
  }
}
