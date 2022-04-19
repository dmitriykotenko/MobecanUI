// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public extension EndOfScreenView {
  
  @discardableResult
  func value(_ value: Button.Value?) -> Self {
    self.value.onNext(value)
    return self
  }
  
  @discardableResult
  func hint(_ hint: String?) -> Self {
    self.hint.onNext(hint)
    return self
  }
  
  @discardableResult
  func errorText(_ errorText: String?) -> Self {
    self.errorText.onNext(errorText)
    return self
  }
}


public extension EndOfScreenView where Button.Value == ButtonForeground {
  
  @discardableResult
  func title(_ title: String) -> Self {
    self.value.onNext(.title(title))
    return self
  }
}
