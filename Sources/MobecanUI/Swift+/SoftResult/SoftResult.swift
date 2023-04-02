// Copyright © 2023 Mobecan. All rights reserved.


/// Is analogous to Swift.Result, but has an additional `.hybrid` case,
/// containing both Success value and error.
public enum SoftResult<Success, Failure: Error> {

  case success(Success)
  case hybrid(value: Success, error: Failure)
  case failure(Failure)

  public init(_ result: Result<Success, Failure>) {
    switch result {
    case .success(let value):
      self = .success(value)
    case .failure(let error):
      self = .failure(error)
    }
  }

  /// Converts SoftResult to Swift.Result.
  /// - Parameter bias: How to interpret `.hybrid` case: as `.success` or as `.failure`.
  public func asResult(biasedTo bias: SoftResultBias) -> Result<Success, Failure> {
    switch (self, bias) {
    case (.success(let value), _):
      return .success(value)
    case (.hybrid(let value, _), .success):
      return .success(value)
    case (.hybrid(_, let error), .failure):
      return .failure(error)
    case (.failure(let error), _):
      return .failure(error)
    }
  }

  public func get() throws -> Success {
    switch self {
    case .success(let value):
      return value
    case .hybrid(let value, _):
      return value
    case .failure(let error):
      throw error
    }
  }

  public var value: Success? {
    try? get()
  }

  public var error: Failure? {
    switch self {
    case .success:
      return nil
    case .hybrid(_, let error):
      return error
    case .failure(let error):
      return error
    }
  }

  public var hasValue: Bool {
    value != nil
  }

  public var hasError: Bool {
    error != nil
  }

  public var isSuccess: Bool {
    switch self {
    case .success:
      return true
    case .hybrid, .failure:
      return false
    }
  }

  public func isNotNilSuccess<Element>(and condition: (Element) -> Bool = { _ in true }) -> Bool
  where Success == Element? {
    switch self {
    case .success(let value?) where condition(value):
      return true
    default:
      return false
    }
  }
}


extension SoftResult: Equatable where Success: Equatable, Failure: Equatable {}
extension SoftResult: Hashable where Success: Hashable, Failure: Hashable {}
extension SoftResult: Codable where Success: Codable, Failure: Codable {}
