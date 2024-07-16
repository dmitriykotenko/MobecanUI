// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


public struct EmptyGeneratorsFactory: GeneratorsFactory {

  public init() {}

  public func generator<Value>(_: Value.Type) -> MobecanGenerator<Value>? { nil }
}
