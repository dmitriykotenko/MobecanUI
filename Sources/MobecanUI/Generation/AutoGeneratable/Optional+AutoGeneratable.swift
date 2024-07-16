// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


extension Optional: AutoGeneratable where Wrapped: AutoGeneratable {

  public class BuiltinGenerator: MobecanGenerator<Wrapped?> {

    public var isNil: MobecanGenerator<IsNil>
    public var wrapped: MobecanGenerator<Wrapped>

    public init(isNil: MobecanGenerator<IsNil> = IsNil.defaultGenerator,
                wrapped: MobecanGenerator<Wrapped> = Wrapped.defaultGenerator) {
      self.isNil = isNil
      self.wrapped = wrapped
    }

    override public func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<Wrapped?>> {
      factory.generate(via: isNil)
        .mapSuccess(\.value)
        .flatMapSuccess { [wrapped] isNil in
          isNil ?
            .just(.success(nil)) :
            factory.generate(via: wrapped).mapSuccess { $0 }
        }
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}


public extension MobecanGenerator {

  func with<Wrapped>(probabilityOfNil: Double) -> MobecanGenerator<Wrapped?> where Value == Wrapped? {
    .rxFunctional {
      Double.random(in: 0...1) <= probabilityOfNil ?
        .just(.success(nil)) :
        self.generate(factory: $0)
    }
  }
}
