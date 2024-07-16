// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


extension MobecanGenerator {

  func filter(_ filter: GeneratorFilter<Value>,
              maximumAttemptsCount: Int) -> MobecanGenerator<Value> {
    .rxFunctional { factory in
      guard maximumAttemptsCount > 0 else {
        return .just(.failure(.nonPositiveAttemptsCount(attemptsCount: maximumAttemptsCount)))
      }

      return self
        .generate(factory: factory)
        .flatMapSuccess { .just(filter($0)) }
        .flatMap {
          switch ($0, maximumAttemptsCount) {
          case (.success(let value), _):
            return .just(.success(value))
          case (.failure(let lastError), 1):
            return .just(.failure(
              .couldNotGenerate(
                Value.self,
                afterAttemptsCount: maximumAttemptsCount,
                lastError: lastError
              )
            ))
          case (.failure, _):
            return self.filter(
              filter,
              maximumAttemptsCount: maximumAttemptsCount - 1
            )
            .generate(factory: factory)
          }
        }
    }
  }
}


extension GeneratorError {

  static func nonPositiveAttemptsCount(attemptsCount: Int) -> GeneratorError {
    .init(
      message: "Attempts count is \(attemptsCount), but it should be positive."
    )
  }

  static func couldNotGenerate<Value>(_ valueType: Value.Type,
                                      afterAttemptsCount attemptsCount: Int,
                                      lastError: GeneratorError) -> GeneratorError {
    let attemptsCountString =
      (attemptsCount == 1) ? "single attempt" : "\(attemptsCount) attempts"

    return .init(
      message: """
      Could not generate \(valueType) after \(attemptsCountString). \
      Last error: \(lastError.message)
      """
    )
  }
}
