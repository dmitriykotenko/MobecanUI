//  Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func errors<Value, SomeError: Error>() -> [SomeError] where Element == Result<Value, SomeError> {
    compactMap {
      if case .failure(let error) = $0 { return error } else { return nil }
    }
  }
  
  func successes<Value, SomeError: Error>() -> [Value] where Element == Result<Value, SomeError> {
    compactMap {
      if case .success(let value) = $0 { return value } else { return nil }
    }
  }

  func successesAndErrors<Value, SomeError: Error>() -> ([Value], [SomeError])
  where Element == Result<Value, SomeError> {
    (successes(), errors())
  }

  /// Превращает [Result<Value, SomeError>] в Result<[Value], SomeError>.
  func invert<Value, SomeError: Error>() -> Result<[Value], SomeError> where Element == Result<Value, SomeError> {
    let initialValue: Result<[Value], SomeError> = .success([])

    return reduce(initialValue) { all, next in
      switch (all, next) {
      case (.success(let allValues), .success(let nextValue)):
        return .success(allValues + [nextValue])
      case (.failure(let error), _):
        return .failure(error)
      case (_, .failure(let error)):
        return .failure(error)
      }
    }
  }
}
