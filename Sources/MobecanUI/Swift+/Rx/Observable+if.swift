// Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public extension ObservableType {

  static func `if`(_ condition: Bool,
                   then firstOperation: @autoclosure () -> Self,
                   else secondOperation: @autoclosure () -> Self) -> Observable<Element> {
    condition ?
      firstOperation().asObservable() :
      secondOperation().asObservable()
  }
}


public extension SharedSequenceConvertibleType {

  static func `if`(_ condition: Bool,
                   then firstOperation: @autoclosure () -> Self,
                   else secondOperation: @autoclosure () -> Self) -> SharedSequence<SharingStrategy, Element> {
    condition ?
    firstOperation().asSharedSequence() :
    secondOperation().asSharedSequence()
  }
}


public extension Single {

  static func `if`(_ condition: Bool,
                   then firstOperation: @autoclosure () -> Self,
                   else secondOperation: @autoclosure () -> Self) -> Self {
    condition ? firstOperation() : secondOperation()
  }
}
