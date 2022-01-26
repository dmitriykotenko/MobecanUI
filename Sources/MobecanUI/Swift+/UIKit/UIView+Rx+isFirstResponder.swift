// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public extension Reactive where Base: UIView {

  var isFirstResponder: Driver<Bool> {
    FirstResponderListener(view: base).asObservable()
      .asDriver(onErrorJustReturn: false)
  }
}


private class FirstResponderListener: ObservableConvertibleType {
  
  typealias Element = Bool

  private weak var view: UIView?

  private let relay: BehaviorRelay<Bool>
  
  init(view: UIView) {
    self.view = view
    self.relay = BehaviorRelay(value: view.isFirstResponder)
  
    listenNotifications([
      UITextField.textDidBeginEditingNotification,
      UITextField.textDidEndEditingNotification,
      UITextView.textDidBeginEditingNotification,
      UITextView.textDidEndEditingNotification
    ])
  }
  
  private func listenNotifications(_ notifications: [NSNotification.Name]) {
    notifications.forEach {
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(update),
        name: $0,
        object: view
      )
    }
  }
  
  @objc
  private func update() {
    if let view = view {
      relay.accept(view.isFirstResponder)
    }
  }
  
  func asObservable() -> Observable<Bool> {
    relay.asObservable().keepStrongReference(to: self)
  }
}
