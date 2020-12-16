//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public extension ObservableType where Element == Void {

  func mapToTrue() -> Observable<Bool> {
    map { _ in true }
  }

  func mapToFalse() -> Observable<Bool> {
    map { _ in false }
  }
}


public extension SharedSequenceConvertibleType where Element == Void {

  func mapToTrue() -> SharedSequence<SharingStrategy, Bool> {
    map { _ in true }
  }

  func mapToFalse() -> SharedSequence<SharingStrategy, Bool> {
    map { _ in false }
  }
}


public extension Single where Element == Void {

  func mapToTrue() -> Single<Bool> {
    asObservable().mapToTrue().asSingle()
  }

  func mapToFalse() -> Single<Bool> {
    asObservable().mapToFalse().asSingle()
  }
}
