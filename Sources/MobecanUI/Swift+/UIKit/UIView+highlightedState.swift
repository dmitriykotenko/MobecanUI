//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public extension UIView {
  
  func highlightOnTaps(disposeBag: DisposeBag) {
    rx.touchDownGesture()
      .when(.began)
      .map { _ in 0.5 }
      .bind(to: rx.alpha )
      .disposed(by: disposeBag)
    
    rx.touchDownGesture()
      .when(.ended, .failed, .cancelled)
      .map { _ in 1.0 }
      .bind(to: rx.alpha)
      .disposed(by: disposeBag)
  }
}
