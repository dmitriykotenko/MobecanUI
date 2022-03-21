// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


class SafeAreaInsetsListener {
  
  @RxDriverOutput(.zero) var insets: Driver<UIEdgeInsets>
  
  @RxOutput(()) private var insetsChanged: Observable<Void>
  
  private weak var view: UIView?
  private var additionalInsetsListeners: [NSKeyValueObservation] = []
  
  private let disposeBag = DisposeBag()

  init(view: UIView,
       windowChanged: Observable<Void>,
       transform: @escaping () -> UIEdgeInsets) {
    self.view = view

    disposeBag {
      windowChanged.startWith(()) ==> { [weak self] in
        self?.updateAdditionalInsetsListeners()
      }

      insetsChanged.map { transform() } ==> _insets
    }
  }
  
  private func updateAdditionalInsetsListeners() {
    print("Window changed to: \(String(describing: view?.window)).")
    
    _insetsChanged.onNext(())
    
    let parentViewControllers = view?.parentViewControllers ?? []
    
    additionalInsetsListeners = parentViewControllers
      .map { $0.observe(\.additionalSafeAreaInsets) { [weak self] _, _ in self?._insetsChanged.onNext(()) } }
  }
}


private extension UIView {
  
  var parentViewControllers: [UIViewController] {
    parentViewController.asSequence
  }
}
