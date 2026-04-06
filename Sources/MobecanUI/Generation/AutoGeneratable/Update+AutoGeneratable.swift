// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


extension Update: AutoGeneratable where Value: AutoGeneratable {

  public final class BuiltinGenerator: MobecanGenerator<Update<Value>> {

    public var old: MobecanGenerator<Value>
    public var new: MobecanGenerator<Value>

    public init(old: MobecanGenerator<Value> = Value.defaultGenerator,
                new: MobecanGenerator<Value> = Value.defaultGenerator) {
      self.old = old
      self.new = new
      super.init()
    }

    public static func using(
      old: MobecanGenerator<Value> = Value.defaultGenerator,
      new: MobecanGenerator<Value> = Value.defaultGenerator
    ) -> BuiltinGenerator {
      .init(
        old: old,
        new: new
      )
    }

    override public func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<Update<Value>>> {
      Single
        .zip(
          factory.generate(via: old),
          factory.generate(via: new)
        )
        .map { zip($0, $1) }
        .mapSuccess {
          .init(
            old: $0,
            new: $1
          )
        }
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}
