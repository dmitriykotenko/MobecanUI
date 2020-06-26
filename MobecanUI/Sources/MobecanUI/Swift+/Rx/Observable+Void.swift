//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public extension ObservableType {
  
  func mapToVoid() -> Observable<Void> {
    return map { _ in () }
  }
}


public extension SharedSequenceConvertibleType {
  
  func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
    return map { _ in () }
  }
}


public extension ObservableType where Element == Void {
  
  func mapToTrue() -> Observable<Bool> {
    return map { _ in true }
  }

  func mapToFalse() -> Observable<Bool> {
    return map { _ in false }
  }
}


public extension SharedSequenceConvertibleType where Element == Void {
  
  func mapToTrue() -> SharedSequence<SharingStrategy, Bool> {
    return map { _ in true }
  }
  
  func mapToFalse() -> SharedSequence<SharingStrategy, Bool> {
    return map { _ in false }
  }
}
