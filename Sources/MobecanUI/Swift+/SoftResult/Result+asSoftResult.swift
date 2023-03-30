// Copyright © 2023 Mobecan. All rights reserved.


public extension Result {

  var asSoftResult: SoftResult<Success, Failure> {
    switch self {
    case .success(let value):
      return .success(value)
    case .failure(let error):
      return .failure(error)
    }
  }
}
