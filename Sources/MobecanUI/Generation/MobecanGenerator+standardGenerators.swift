// Copyright © 2024 Mobecan. All rights reserved.

import NonEmpty
import RxSwift


public extension MobecanGenerator {

  static func fixed(_ value: Value) -> MobecanGenerator<Value> {
    .pure { value }
  }

  static func either(_ variants: NonEmptyArray<Value>) -> MobecanGenerator<Value> {
    .functional { _ in variants.randomElement() }
  }

  static func oneOf(_ firstVariant: Value,
                           _ otherVariants: Value...) -> MobecanGenerator<Value> {
    .functional { _ in
      ([firstVariant] + otherVariants).randomElement()!
    }
  }

  static func unsafeEither(_ variants: some Collection<Value>) -> MobecanGenerator<Value> {
    .rxFunctional { _ in
      switch variants.randomElement() {
      case nil:
        return .just(.failure(
          .init(message: "Trying to generate random element from empty array of \(Value.self)")
        ))
      case let element?:
        return .just(.success(element))
      }
    }
  }

  var optional: MobecanGenerator<Value?> {
    .rxFunctional {
      Bool.random() ?
        .just(.success(nil)) :
        self.generate(factory: $0).mapSuccess { $0 }
    }
  }

  func array(count: Range<Int>) -> MobecanGenerator<[Value]> {
    .rxFunctional { factory in
      let length = Int.random(in: count)

      return Single
        .zip((0..<length) .map {  _ in self.generate(factory: factory) })
        .map { $0.invert() }
    }
  }

  func array(exactCount: Int) -> MobecanGenerator<[Value]> {
    array(count: exactCount..<(exactCount + 1))
  }

  func set(count: Range<Int>,
           filter: GeneratorFilter<Value> = .alwaysSuccess()) -> MobecanGenerator<Set<Value>>
  where Value: Hashable {
    .rxFunctional { factory in
      let length = Int.random(in: count)
      let maximumAttemptsCount = 20

      return self
        .filter(filter, maximumAttemptsCount: maximumAttemptsCount)
        .generate(factory: factory)
        .flatMapSuccess { first in
          length == 1 ?
            .just(.success([first])) :
          self
            .filter(
              filter.combine(with: .isNotEqual(to: first)),
              maximumAttemptsCount: maximumAttemptsCount
            )
            .set(exactCount: length - 1)
            .generate(factory: factory)
            .mapSuccess { tail in tail.union([first]) }
        }
    }
  }

  func set(exactCount: Int) -> MobecanGenerator<Set<Value>> where Value: Hashable {
    set(count: exactCount..<(exactCount + 1))
  }
}
