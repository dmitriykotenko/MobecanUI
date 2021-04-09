//  Copyright © 2020 Mobecan. All rights reserved.


public extension Dictionary {

  func with(key: Key, value: Value?) -> Self {
    var result = self
    result[key] = value
    return result
  }

  func replacing(key: Key,
                 newValue: Value?,
                 if isNotEqual: (Value?, Value?) -> Bool) -> Self {
    isNotEqual(newValue, self[key]) ?
      self.with(key: key, value: newValue) :
    self
  }

  func without(key: Key) -> Self {
    with(key: key, value: nil)
  }
}
