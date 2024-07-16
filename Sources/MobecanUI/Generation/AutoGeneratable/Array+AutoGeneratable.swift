// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


extension Array: AutoGeneratable where Element: AutoGeneratable {

  public class BuiltinGenerator: MobecanGenerator<[Element]> {

    public var count: MobecanGenerator<SequenceLength>
    public var element: MobecanGenerator<Element>

    public init(count: MobecanGenerator<SequenceLength> = SequenceLength.defaultGenerator,
                element: MobecanGenerator<Element> = Element.defaultGenerator) {
      self.count = count
      self.element = element
    }

    override public func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<[Element]>> {
      factory.generate(via: count)
        .mapSuccess(\.value)
        .flatMapSuccess { [element] length in
          Single
            .zip((0..<length).map { _ in factory.generate(via: element) })
            .map { $0.invert() }
        }
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}


extension MobecanGenerator {

  public static func builtin<Element>(
    count: MobecanGenerator<SequenceLength> = SequenceLength.defaultGenerator,
    element: MobecanGenerator<Element> = Element.defaultGenerator
  ) -> MobecanGenerator<[Element]> where Value == [Element], Element: AutoGeneratable {
    [Element].BuiltinGenerator(count: count, element: element)
  }
}
