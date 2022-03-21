// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import SwiftDateTime
import UIKit


public extension UIViewController {

  func pinBottomEdgeToKeyboard(subview: UIView,
                               spacing: CGFloat,
                               disposeBag: DisposeBag) {
    
    var bottomConstraint: Constraint?
    
    subview.snp.makeConstraints {
      $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide)
      
      bottomConstraint = $0.bottom
        .equalToSuperview()
        .inset(spacing)
        .priority(.high)
        .constraint
    }

    disposeBag {
      RxKeyboard.instance.visibleHeight ==> { [weak self] keyboardHeight in
        UIView.animate(
          withDuration: Duration.keyboardAnimation.toTimeInterval,
          delay: 0,
          options: .curveEaseInOut,
          animations: {
            bottomConstraint?.update(inset: keyboardHeight + spacing)
            self?.view.layoutIfNeeded()
          },
          completion: nil
        )
      }
    }
  }
}


public extension Duration {
  
  static var keyboardAnimation: Duration { 250.milliseconds }
}
