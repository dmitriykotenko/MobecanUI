// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


open class FunctionalGenerator<Value>: MobecanGenerator<Value> {

  public var generateValue: (GeneratorsFactory) -> Single<GeneratorResult<Value>>

  public init(generateValue: @escaping (GeneratorsFactory) -> Single<GeneratorResult<Value>>) {
    self.generateValue = generateValue
  }

  override open func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<Value>> {
    generateValue(factory)
  }
}


public extension MobecanGenerator {

  static func using(_ nested: MobecanGenerator<Value>) -> FunctionalGenerator<Value> {
    .init {
      nested.generate(factory: $0)
    }
  }

  static func pure(_ generateValue: @escaping () -> Value) -> FunctionalGenerator<Value> {
    .init { _ in .just(.success(generateValue())) }
  }

  static func rxPure(_ generateValue: @escaping () -> Single<GeneratorResult<Value>>) -> FunctionalGenerator<Value> {
    .init { _ in generateValue() }
  }

  static func functional(_ generateValue: @escaping (GeneratorsFactory) -> Value) -> FunctionalGenerator<Value> {
    .init {  .just(.success(generateValue($0))) }
  }

  static func rxFunctional(_ generateValue: @escaping (GeneratorsFactory) -> Single<GeneratorResult<Value>>)
  -> FunctionalGenerator<Value> {
    .init(generateValue: generateValue)
  }
}
