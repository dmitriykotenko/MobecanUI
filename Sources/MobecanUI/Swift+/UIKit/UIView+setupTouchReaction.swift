// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public extension UIView {

  func setupTouchReaction(onTouchDown: @escaping () -> Void,
                          onTouchUp: @escaping () -> Void,
                          disposeBag: DisposeBag) {
    disposeBag {
      rx.touchDownGesture()
        .when(.began)
        ==> { _ in onTouchDown() }

      rx.touchDownGesture()
        .when(.ended, .failed, .cancelled)
        ==> { _ in onTouchUp() }
    }
  }

  func highlightOnTaps(disposeBag: DisposeBag) {
    setupTouchReaction(
      onTouchDown: { [weak self] in self?.alpha = 0.5 },
      onTouchUp: { [weak self] in self?.alpha = 1.0 },
      disposeBag: disposeBag
    )
  }
}
