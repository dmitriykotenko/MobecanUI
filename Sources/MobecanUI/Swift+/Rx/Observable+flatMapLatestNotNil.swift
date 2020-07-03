//  Copyright © 2020 Mobecan. All rights reserved.


import RxOptional
import RxSwift


public extension ObservableType {
  
  /// If value is not nil, transforms it to observable sequences via `transform` parameter.
  /// If value is nil, transforms it to `Observable.just(nil)`.
  func flatMapLatestNotNil<Value, AnotherValue>(_ transform: @escaping (Value) -> Observable<AnotherValue?>)
    -> Observable<AnotherValue?> where Element == Value? {
      
      flatMapLatest { valueOrNil -> Observable<AnotherValue?> in
        switch valueOrNil {
        case nil:
          return .just(nil)
        case let value?:
          return transform(value)
        }
      }
  }
}
