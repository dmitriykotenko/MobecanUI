// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension EditableField {
  
  @discardableResult
  func texts(_ texts: EditableFieldTexts) -> Self {
    self.texts.onNext(texts)
    return self
  }
  
  @discardableResult
  func doNotDisturbMode(_ doNotDisturbMode: DoNotDisturbMode) -> Self {
    self.doNotDisturbMode.onNext(doNotDisturbMode)
    return self
  }
  
  @discardableResult
  func initialRawValue(_ initialRawValue: RawValue) -> Self {
    self.initialRawValue.onNext(initialRawValue)
    return self
  }
}
