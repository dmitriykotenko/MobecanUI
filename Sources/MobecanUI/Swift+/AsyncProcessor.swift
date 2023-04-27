// Copyright © 2023 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public struct AsyncProcessor<Value, SomeError: Error> {
  
  public let process: (Value) -> Single<Result<Value, SomeError>>
  
  public init(_ process: @escaping (Value) -> Single<Result<Value, SomeError>>) {
    self.process = process
  }
  
  public static func immediateSuccess() -> AsyncProcessor<Value, SomeError> {
    AsyncProcessor { .just(.success($0)) }
  }
}
