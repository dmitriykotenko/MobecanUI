//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public struct Saver<Value, SomeError: Error> {
  
  public let save: (Value) -> Single<Result<Value, SomeError>>
  
  public init(_ save: @escaping (Value) -> Single<Result<Value, SomeError>>) {
    self.save = save
  }
  
  public static func immediateSuccess() -> Saver<Value, SomeError> {
    Saver { .just(.success($0)) }
  }
}
