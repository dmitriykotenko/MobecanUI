// Copyright © 2024 Mobecan. All rights reserved.

import NonEmpty


// swiftlint:disable function_parameter_count
// swiftlint:disable large_tuple
public extension Result where Failure: ComposableError {

  static func tryInit<A, B, C, D, E, F, G>(
    _ valueA: Result<A, Failure>, _ keyA: String,
    _ valueB: Result<B, Failure>, _ keyB: String,
    _ valueC: Result<C, Failure>, _ keyC: String,
    _ valueD: Result<D, Failure>, _ keyD: String,
    _ valueE: Result<E, Failure>, _ keyE: String,
    _ valueF: Result<F, Failure>, _ keyF: String,
    _ valueG: Result<G, Failure>, _ keyG: String
  ) -> Result<Success, Failure> where Success == (A, B, C, D, E, F, G) {

    var errors: [String: Failure] = [:]

    valueA.asError.map { errors[keyA] = $0 }
    valueB.asError.map { errors[keyB] = $0 }
    valueC.asError.map { errors[keyC] = $0 }

    valueD.asError.map { errors[keyD] = $0 }
    valueE.asError.map { errors[keyE] = $0 }
    valueF.asError.map { errors[keyF] = $0 }

    valueG.asError.map { errors[keyG] = $0 }

    if let nonEmptyErrors = NonEmpty(rawValue: errors) {
      return .failure(.composed(from: nonEmptyErrors))
    }

    // swiftlint:disable:next force_try
    return try! .success((
      valueA.get(),
      valueB.get(),
      valueC.get(),

      valueD.get(),
      valueE.get(),
      valueF.get(),

      valueG.get()
    ))
  }

  static func tryInit<A, B, C, D, E, F, G, H>(
    _ valueA: Result<A, Failure>, _ keyA: String,
    _ valueB: Result<B, Failure>, _ keyB: String,
    _ valueC: Result<C, Failure>, _ keyC: String,
    _ valueD: Result<D, Failure>, _ keyD: String,
    _ valueE: Result<E, Failure>, _ keyE: String,
    _ valueF: Result<F, Failure>, _ keyF: String,
    _ valueG: Result<G, Failure>, _ keyG: String,
    _ valueH: Result<H, Failure>, _ keyH: String
  ) -> Result<Success, Failure> where Success == (A, B, C, D, E, F, G, H) {

    var errors: [String: Failure] = [:]

    valueA.asError.map { errors[keyA] = $0 }
    valueB.asError.map { errors[keyB] = $0 }
    valueC.asError.map { errors[keyC] = $0 }

    valueD.asError.map { errors[keyD] = $0 }
    valueE.asError.map { errors[keyE] = $0 }
    valueF.asError.map { errors[keyF] = $0 }

    valueG.asError.map { errors[keyG] = $0 }
    valueH.asError.map { errors[keyH] = $0 }

    if let nonEmptyErrors = NonEmpty(rawValue: errors) {
      return .failure(.composed(from: nonEmptyErrors))
    }

    // swiftlint:disable:next force_try
    return try! .success((
      valueA.get(),
      valueB.get(),
      valueC.get(),

      valueD.get(),
      valueE.get(),
      valueF.get(),

      valueG.get(),
      valueH.get()
    ))
  }

  static func tryInit<A, B, C, D, E, F, G, H, I>(
    _ valueA: Result<A, Failure>, _ keyA: String,
    _ valueB: Result<B, Failure>, _ keyB: String,
    _ valueC: Result<C, Failure>, _ keyC: String,
    _ valueD: Result<D, Failure>, _ keyD: String,
    _ valueE: Result<E, Failure>, _ keyE: String,
    _ valueF: Result<F, Failure>, _ keyF: String,
    _ valueG: Result<G, Failure>, _ keyG: String,
    _ valueH: Result<H, Failure>, _ keyH: String,
    _ valueI: Result<I, Failure>, _ keyI: String
  ) -> Result<Success, Failure> where Success == (A, B, C, D, E, F, G, H, I) {

    var errors: [String: Failure] = [:]

    valueA.asError.map { errors[keyA] = $0 }
    valueB.asError.map { errors[keyB] = $0 }
    valueC.asError.map { errors[keyC] = $0 }

    valueD.asError.map { errors[keyD] = $0 }
    valueE.asError.map { errors[keyE] = $0 }
    valueF.asError.map { errors[keyF] = $0 }

    valueG.asError.map { errors[keyG] = $0 }
    valueH.asError.map { errors[keyH] = $0 }
    valueI.asError.map { errors[keyI] = $0 }

    if let nonEmptyErrors = NonEmpty(rawValue: errors) {
      return .failure(.composed(from: nonEmptyErrors))
    }

    // swiftlint:disable:next force_try
    return try! .success((
      valueA.get(),
      valueB.get(),
      valueC.get(),

      valueD.get(),
      valueE.get(),
      valueF.get(),

      valueG.get(),
      valueH.get(),
      valueI.get()
    ))
  }
}
