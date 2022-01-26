// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public extension ObservableType where Element == Bool {
  
  func and<ThatObservableType: ObservableType>(_ that: ThatObservableType) -> Observable<Bool>
    where ThatObservableType.Element == Bool {
      
      Observable.combineLatest(self, that) { $0 && $1 }
  }
  
  func or<ThatObservableType: ObservableType>(_ that: ThatObservableType) -> Observable<Bool>
    where ThatObservableType.Element == Bool {
      
      Observable.combineLatest(self, that) { $0 || $1 }
  }
  
  func not() -> Observable<Bool> {
    map { !$0 }
  }

  func whenTrue() -> Observable<Void> {
    whenIsEqual(to: true)
  }

  func whenFalse() -> Observable<Void> {
    whenIsEqual(to: false)
  }

  static func not<SomeObservable: ObservableType>(_ observable: SomeObservable) -> Observable<Bool>
  where SomeObservable.Element == Bool {
    observable.not()
  }
}
