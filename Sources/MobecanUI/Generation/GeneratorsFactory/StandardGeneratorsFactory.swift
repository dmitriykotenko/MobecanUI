// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


open class StandardGeneratorsFactory: GeneratorsFactory {

  private var generators: [(Any, Any.Type)] = []

  public init() {}

  open func generator<Value>(_ valueType: Value.Type) -> MobecanGenerator<Value>? {
    let anyGenerator = generators.first { $1 == valueType }?.0

    return anyGenerator as? MobecanGenerator<Value>
  }

  open func setGenerator<Value: AutoGeneratable>(_ generator: MobecanGenerator<Value>?,
                                                 for valueType: Value.Type = Value.self) {
    switch generator {
    case let someGenerator?:
      generators = generators.upsert((someGenerator, valueType), compareBy: { $0.1 == $1.1 })
    case nil:
      generators = generators.filter { $1 != valueType }
    }
  }

  @discardableResult
  open func with<Value: AutoGeneratable>(generating valueType: Value.Type = Value.self,
                                         by generator: MobecanGenerator<Value>?) -> Self {
    setGenerator(generator, for: valueType)
    return self
  }
}
