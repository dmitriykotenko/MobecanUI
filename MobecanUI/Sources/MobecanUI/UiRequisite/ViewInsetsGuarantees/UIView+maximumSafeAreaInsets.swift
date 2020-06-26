//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


extension UIView {
  
  var maximumSafeAreaInsets: UIEdgeInsets {
    let guarantee = parentViewController as? SafeAreaInsetsGuarantee
    
    let guaranteedInsets = guarantee?.guaranteedSafeAreaInsets(for: self) ?? .empty
    
    return (parentViewController?.maximumSafeAreaInsets ?? .zero).withOptional(guaranteedInsets)
  }
  
  func maximumSafeAreaInsetsListener(windowChanged: Observable<Void>) -> SafeAreaInsetsListener {
    return SafeAreaInsetsListener(
      view: self,
      windowChanged: windowChanged,
      transform: { [weak self] in self?.maximumSafeAreaInsets ?? .zero }
    )
  }
}


private extension UIResponder {
    
  var parentViewController: UIViewController? {
    return (next as? UIViewController) ?? next?.parentViewController
  }
}


private extension UIViewController {
  
  var maximumSafeAreaInsets: UIEdgeInsets {
    let guarantee = view.superview?.parentViewController as? SafeAreaInsetsGuarantee
    
    let guaranteedInsets = guarantee?.guaranteedSafeAreaInsets(for: view) ?? .empty
    
    let parentInsets =
      parent?.maximumSafeAreaInsets ?? view.window?.safeAreaInsets ?? .zero
    
    return parentInsets.withOptional(guaranteedInsets) + additionalSafeAreaInsets
  }
}
