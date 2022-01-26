// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public extension ObservableType {
  
  func mapToVoid() -> Observable<Void> {
    map { _ in () }
  }
}


public extension SharedSequenceConvertibleType {
  
  func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
    map { _ in () }
  }
}


public extension Single {

  func mapToVoid() -> Single<Void> {
    asObservable().mapToVoid().asSingle()
  }
}
