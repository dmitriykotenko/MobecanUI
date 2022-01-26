// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public extension UIView {

  func setupTouchReaction(onTouchDown: @escaping () -> Void,
                          onTouchUp: @escaping () -> Void,
                          disposeBag: DisposeBag) {
    rx.touchDownGesture()
      .when(.began)
      .subscribe(onNext: { _ in onTouchDown() })
      .disposed(by: disposeBag)

    rx.touchDownGesture()
      .when(.ended, .failed, .cancelled)
      .subscribe(onNext: { _ in onTouchUp() })
      .disposed(by: disposeBag)
  }

  func highlightOnTaps(disposeBag: DisposeBag) {
    setupTouchReaction(
      onTouchDown: { [weak self] in self?.alpha = 0.5 },
      onTouchUp: { [weak self] in self?.alpha = 1.0 },
      disposeBag: disposeBag
    )
  }
}
