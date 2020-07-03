//  Copyright © 2020 Mobecan. All rights reserved.

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
