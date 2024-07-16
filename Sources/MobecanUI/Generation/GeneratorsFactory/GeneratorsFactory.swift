// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


public protocol GeneratorsFactory {

  func generator<Value>(_: Value.Type) -> MobecanGenerator<Value>?
}


public extension GeneratorsFactory {

  func generate<Value>(via defaultGenerator: MobecanGenerator<Value>) -> Single<GeneratorResult<Value>> {
    generator(Value.self)?.generate(factory: self)
    ?? defaultGenerator.generate(factory: self)
  }
}
