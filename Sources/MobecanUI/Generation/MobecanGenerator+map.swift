// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


public extension MobecanGenerator {

  func map<OtherValue>(_ transform: @escaping (Value) -> OtherValue) -> MobecanGenerator<OtherValue> {
    .rxFunctional {
      self.generate(factory: $0).mapSuccess(transform)
    }
  }

  func rxMap<OtherValue>(_ transform: @escaping (Value) -> Single<GeneratorResult<OtherValue>>)
  -> MobecanGenerator<OtherValue> {
    .rxFunctional {
      self.generate(factory: $0).flatMapSuccess(transform)
    }
  }

  func flatMap<OtherValue>(_ transform: @escaping (Value) -> MobecanGenerator<OtherValue>)
  -> MobecanGenerator<OtherValue> {
    .rxFunctional { factory in
      self.generate(factory: factory).flatMapSuccess {
        transform($0).generate(factory: factory)
      }
    }
  }
}
