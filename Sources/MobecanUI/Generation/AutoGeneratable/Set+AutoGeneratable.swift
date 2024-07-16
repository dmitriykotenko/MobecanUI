// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


extension Set: AutoGeneratable where Element: AutoGeneratable {

  public class BuiltinGenerator: MobecanGenerator<Set<Element>> {

    public var count: MobecanGenerator<SequenceLength>
    public var element: MobecanGenerator<Element>

    public init(count: MobecanGenerator<SequenceLength> = SequenceLength.defaultGenerator,
                element: MobecanGenerator<Element> = Element.defaultGenerator) {
      self.count = count
      self.element = element
    }

    override public func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<Set<Element>>> {
      factory.generate(via: count)
        .mapSuccess(\.value)
        .flatMapSuccess { length in
          self.generate(factory: factory, count: length)
        }
    }

    private func generate(
      factory: any GeneratorsFactory,
      count: UInt,
      filter: GeneratorFilter<Element> = .alwaysSuccess()
    ) -> Single<GeneratorResult<Set<Element>>> {
      guard count > 0 else { return .just(.success([])) }

      let maximumAttemptsCount = 20

      return factory
        .generate(via: element.filter(filter, maximumAttemptsCount: maximumAttemptsCount))
        .flatMapSuccess { first in
          switch count {
          case 1:
            return .just(.success([first]))
          default:
            return self
              .generate(
                factory: factory,
                count: count - 1,
                filter: filter.combine(with: .isNotEqual(to: first))
              )
              .mapSuccess { tail in tail.union([first]) }
          }
        }
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}


extension MobecanGenerator {

  public static func builtin<Element>(
    count: MobecanGenerator<SequenceLength> = SequenceLength.defaultGenerator,
    element: MobecanGenerator<Element> = Element.defaultGenerator
  ) -> MobecanGenerator<Set<Element>> where Value == Set<Element>, Element: AutoGeneratable {
    Set<Element>.BuiltinGenerator(count: count, element: element)
  }
}
