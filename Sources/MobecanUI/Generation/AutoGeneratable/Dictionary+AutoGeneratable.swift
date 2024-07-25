// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


extension Dictionary: AutoGeneratable where Key: AutoGeneratable, Value: AutoGeneratable {

  public class BuiltinGenerator: MobecanGenerator<[Key: Value]> {

    public var count: MobecanGenerator<SequenceLength>
    public var key: MobecanGenerator<Key>
    public var value: MobecanGenerator<Value>

    init(count: MobecanGenerator<SequenceLength> = SequenceLength.defaultGenerator,
         key: MobecanGenerator<Key> = Key.defaultGenerator,
         value: MobecanGenerator<Value> = Value.defaultGenerator) {
      self.count = count
      self.key = key
      self.value = value
    }

    override public func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<[Key: Value]>> {
      factory.generate(via: count)
        .flatMapSuccess { [key, value] length in
          Single
            .zip(
              factory.generate(via: Set<Key>.BuiltinGenerator(count: .fixed(length), element: key)),
              factory.generate(via: [Value].BuiltinGenerator(count: .fixed(length), element: value))
            )
            .map { zip($0, $1) }
            .mapSuccess { keys, values in
              Dictionary(uniqueKeysWithValues: zip(keys, values))
            }
        }
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}


extension MobecanGenerator {

  public static func builtin<Key: Hashable & AutoGeneratable, SomeValue: AutoGeneratable>(
    count: MobecanGenerator<SequenceLength> = SequenceLength.defaultGenerator,
    key: MobecanGenerator<Key> = Key.defaultGenerator,
    value: MobecanGenerator<SomeValue> = SomeValue.defaultGenerator
  ) -> MobecanGenerator<[Key: SomeValue]> where Value == [Key: SomeValue] {
    [Key: SomeValue].BuiltinGenerator(
      count: count,
      key: key,
      value: value
    )
  }
}
