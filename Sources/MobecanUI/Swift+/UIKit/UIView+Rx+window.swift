//  Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public extension Reactive where Base: UIView {
  
  var window: Observable<UIWindow?> {
    methodInvoked(#selector(UIView.didMoveToWindow))
      .compactMap { [weak base] _ in base?.window }
  }

  var windowChanged: Observable<Void> {
    methodInvoked(#selector(UIView.didMoveToWindow)).mapToVoid()
  }
}
