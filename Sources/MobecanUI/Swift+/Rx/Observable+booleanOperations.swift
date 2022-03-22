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


public extension SharedSequenceConvertibleType where Element == Bool {

  func and<That: SharedSequenceConvertibleType>(_ that: That) -> SharedSequence<SharingStrategy, Bool>
  where That.SharingStrategy == SharingStrategy, That.Element == Bool {

    SharedSequence.combineLatest(self, that) { $0 && $1 }
  }

  func or<That: SharedSequenceConvertibleType>(_ that: That) -> SharedSequence<SharingStrategy, Bool>
  where That.SharingStrategy == SharingStrategy, That.Element == Bool {

    SharedSequence.combineLatest(self, that) { $0 || $1 }
  }

  func not() -> SharedSequence<SharingStrategy, Bool> {
    map { !$0 }
  }

  static func not<SomeSequence: SharedSequenceConvertibleType>(_ sequence: SomeSequence)
  -> SharedSequence<SharingStrategy, Bool>
  where SomeSequence.SharingStrategy == SharingStrategy, SomeSequence.Element == Bool {

    sequence.not()
  }
}


public extension PrimitiveSequence where Trait == SingleTrait, Element == Bool {

  func and(_ that: Single<Bool>) -> Single<Bool> {
    self.asObservable().and(that.asObservable())
      .asSingle()
  }

  func or(_ that: Single<Bool>) -> Single<Bool> {
    self.asObservable().or(that.asObservable())
      .asSingle()
  }

  func not() -> Single<Bool> {
    map { !$0 }
  }

  static func not(_ sequence: Single<Bool>) -> Single<Bool> {
    sequence.not()
  }
}
