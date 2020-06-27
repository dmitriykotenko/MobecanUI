//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension EditableField {
  
  func texts(_ texts: EditableFieldTexts) -> Self {
    self.texts.onNext(texts)
    return self
  }
  
  func doNotDisturbMode(_ doNotDisturbMode: DoNotDisturbMode) -> Self {
    self.doNotDisturbMode.onNext(doNotDisturbMode)
    return self
  }
  
  func initialRawValue(_ initialRawValue: RawValue) -> Self {
    self.initialRawValue.onNext(initialRawValue)
    return self
  }
}
