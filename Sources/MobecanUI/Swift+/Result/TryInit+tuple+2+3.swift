// Copyright © 2024 Mobecan. All rights reserved.

import NonEmpty


// swiftlint:disable function_parameter_count
// swiftlint:disable large_tuple
public extension Result where Failure: ComposableError {

  static func tryInit<A, B>(
    _ valueA: Result<A, Failure>, _ keyA: String,
    _ valueB: Result<B, Failure>, _ keyB: String
  ) -> Result<Success, Failure> where Success == (A, B) {

    var errors: [String: Failure] = [:]

    valueA.asError.map { errors[keyA] = $0 }
    valueB.asError.map { errors[keyB] = $0 }

    if let nonEmptyErrors = NonEmpty(rawValue: errors) {
      return .failure(.composed(from: nonEmptyErrors))
    }

    // swiftlint:disable:next force_try
    return try! .success((
      valueA.get(),
      valueB.get()
    ))
  }

  static func tryInit<A, B, C>(
    _ valueA: Result<A, Failure>, _ keyA: String,
    _ valueB: Result<B, Failure>, _ keyB: String,
    _ valueC: Result<C, Failure>, _ keyC: String
  ) -> Result<Success, Failure> where Success == (A, B, C) {

    var errors: [String: Failure] = [:]

    valueA.asError.map { errors[keyA] = $0 }
    valueB.asError.map { errors[keyB] = $0 }
    valueC.asError.map { errors[keyC] = $0 }

    if let nonEmptyErrors = NonEmpty(rawValue: errors) {
      return .failure(.composed(from: nonEmptyErrors))
    }

    // swiftlint:disable:next force_try
    return try! .success((
      valueA.get(),
      valueB.get(),
      valueC.get()
    ))
  }
}
