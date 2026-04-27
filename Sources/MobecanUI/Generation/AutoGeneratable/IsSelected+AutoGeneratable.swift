// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


// TODO: Вернуть макрос @DerivesAutoGeneratable, когда придумаю, как подружить его с Xcode 26
extension IsSelected: AutoGeneratable where Value: AutoGeneratable {

  public final class BuiltinGenerator: MobecanGenerator<IsSelected<Value>> {

    public var value: MobecanGenerator<Value>
    public var isSelected: MobecanGenerator<Bool>

    public init(value: MobecanGenerator<Value> = Value.defaultGenerator,
                isSelected: MobecanGenerator<Bool> = Bool.defaultGenerator) {
      self.value = value
      self.isSelected = isSelected
      super.init()
    }

    public static func using(
      value: MobecanGenerator<Value> = Value.defaultGenerator,
      isSelected: MobecanGenerator<Bool> = Bool.defaultGenerator
    ) -> BuiltinGenerator {
      .init(
        value: value,
        isSelected: isSelected
      )
    }

    override public func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<IsSelected<Value>>> {
      Single
        .zip(
          factory.generate(via: value),
          factory.generate(via: isSelected)
        )
        .map { zip($0, $1) }
        .mapSuccess {
          .init(
            value: $0,
            isSelected: $1
          )
        }
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}
