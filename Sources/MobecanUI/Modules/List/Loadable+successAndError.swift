// Copyright © 2020 Mobecan. All rights reserved.


public extension Loadable {

  var isLoading: Bool {
    switch self {
    case .isLoading:
      return true
    default:
      return false
    }
  }

  var asSuccess: Value? {
    switch self {
    case .loaded(.success(let value)):
      return value
    default:
      return nil
    }
  }

  var asError: SomeError? {
    switch self {
    case .loaded(.failure(let error)):
      return error
    default:
      return nil
    }
  }
}
