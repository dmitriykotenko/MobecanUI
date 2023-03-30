// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public struct Checker<InputValue, OutputValue, SomeError: Error> {
  
  public let isOutputValueValid: (InputValue?, SoftResult<OutputValue, SomeError>) -> Bool
  
  public init(_ isOutputValueValid: @escaping (InputValue?, SoftResult<OutputValue, SomeError>) -> Bool) {
    self.isOutputValueValid = isOutputValueValid
  }
  
  public static func alwaysTrue() -> Checker {
    Checker { _, _ in true }
  }
}
