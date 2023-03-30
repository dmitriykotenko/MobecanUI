// Copyright © 2023 Mobecan. All rights reserved.


public extension SoftResult {

  func map<OtherSuccess>(_ transform: (Success) -> OtherSuccess) -> SoftResult<OtherSuccess, Failure> {
    switch self {
    case .success(let value):
      return .success(transform(value))
    case .hybrid(let value, let error):
      return .hybrid(value: transform(value), error: error)
    case .failure(let error):
      return .failure(error)
    }
  }

  func mapError<OtherFailure>(_ transform: (Failure) -> OtherFailure) -> SoftResult<Success, OtherFailure> {
    switch self {
    case .success(let value):
      return .success(value)
    case .hybrid(let value, let error):
      return .hybrid(value: value, error: transform(error))
    case .failure(let error):
      return .failure(transform(error))
    }
  }
}
