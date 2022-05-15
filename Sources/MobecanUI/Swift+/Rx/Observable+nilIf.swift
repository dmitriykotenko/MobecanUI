// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import RxCocoa


public extension ObservableType {

  func nilIf<T, Predicate: ObservableConvertibleType>(_ predicate: Predicate) -> Observable<T?>
  where T? == Element, Predicate.Element == Bool {

    Observable.combineLatest(predicate.asObservable(), self) { $0 ? nil : $1 }
  }

  func nilIfNot<T, Predicate: ObservableConvertibleType>(_ predicate: Predicate) -> Observable<T?>
  where T? == Element, Predicate.Element == Bool {

    nilIf(predicate.asObservable().map { !$0 })
  }

  func nilIf<Predicate: ObservableConvertibleType>(_ predicate: Predicate) -> Observable<Element?>
  where Predicate.Element == Bool {

    let optionalSelf: Observable<Element?> = map { $0 }
    
    return optionalSelf.nilIf(predicate)
  }
  
  func nilIfNot<Predicate: ObservableConvertibleType>(_ predicate: Predicate) -> Observable<Element?>
  where Predicate.Element == Bool {

    let optionalSelf: Observable<Element?> = map { $0 }
    
    return optionalSelf.nilIfNot(predicate)
  }
}


public extension SharedSequenceConvertibleType {

  func nilIf<T, Predicate: SharedSequenceConvertibleType>(_ predicate: Predicate)
  -> SharedSequence<SharingStrategy, T?>
  where T? == Element, Predicate.Element == Bool, Predicate.SharingStrategy == SharingStrategy {

    SharedSequence.combineLatest(predicate, self) { $0 ? nil : $1 }
  }

  func nilIfNot<T, Predicate: SharedSequenceConvertibleType>(_ predicate: Predicate)
  -> SharedSequence<SharingStrategy, T?>
  where T? == Element, Predicate.Element == Bool, Predicate.SharingStrategy == SharingStrategy {

    nilIf(predicate.map { !$0 })
  }

  func nilIf<Predicate: SharedSequenceConvertibleType>(_ predicate: Predicate)
  -> SharedSequence<SharingStrategy, Element?>
  where Predicate.Element == Bool, Predicate.SharingStrategy == SharingStrategy {

    let optionalSelf: SharedSequence<SharingStrategy, Element?> = map { $0 }

    return optionalSelf.nilIf(predicate)
  }

  func nilIfNot<Predicate: SharedSequenceConvertibleType>(_ predicate: Predicate)
  -> SharedSequence<SharingStrategy, Element?>
  where Predicate.Element == Bool, Predicate.SharingStrategy == SharingStrategy {

    let optionalSelf: SharedSequence<SharingStrategy, Element?> = map { $0 }

    return optionalSelf.nilIfNot(predicate)
  }
}
