// Copyright © 2021 Mobecan. All rights reserved.


public extension Result {

  var asSuccess: Success? {
    switch self {
    case .success(let value):
      return value
    case .failure:
      return nil
    }
  }

  var asError: Failure? {
    switch self {
    case .success:
      return nil
    case .failure(let error):
      return error
    }
  }
}
