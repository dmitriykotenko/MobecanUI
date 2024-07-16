// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


public extension MobecanGenerator where Value: AutoGeneratable {

  static func builtin(_ builtinGenerator: Value.BuiltinGenerator = Value.defaultGenerator) -> MobecanGenerator<Value> {
    builtinGenerator
  }
}
