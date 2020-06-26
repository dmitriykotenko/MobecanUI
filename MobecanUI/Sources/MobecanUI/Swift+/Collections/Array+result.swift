//  Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func errors<Value, SomeError: Error>() -> [SomeError] where Element == Result<Value, SomeError> {
    return compactMap {
      if case .failure(let error) = $0 { return error } else { return nil }
    }
  }
  
  func successes<Value, SomeError: Error>() -> [Value] where Element == Result<Value, SomeError> {
    return compactMap {
      if case .success(let value) = $0 { return value } else { return nil }
    }
  }
}
