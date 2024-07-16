// Copyright © 2024 Mobecan. All rights reserved.

import NonEmpty
import RxSwift


open class MobecanGenerator<Value> {

  public init() {}

  open func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<Value>> {
    .just(.failure(
      .init(message: "Abstract non-implemented MobecanGenerator<\(Value.self)>")
    ))
  }
}
