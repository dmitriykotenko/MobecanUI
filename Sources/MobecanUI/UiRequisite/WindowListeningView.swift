// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


/// View which listens its own `window` property.
public class WindowListeningView: UIView {
  
  @RxSignalOutput public var windowChanged: Signal<Void>
  
  override public func didMoveToWindow() {
    _windowChanged.onNext(())
  }
}
