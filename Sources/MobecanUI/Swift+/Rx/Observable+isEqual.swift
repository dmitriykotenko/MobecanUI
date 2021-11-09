// Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public extension ObservableType where Element: Equatable {

  func isEqual(to element: Element) -> Observable<Bool> {
    map { $0 == element }
  }

  func isNotEqual(to element: Element) -> Observable<Bool> {
    map { $0 != element }
  }
}


public extension SharedSequence where Element: Equatable {

  func isEqual(to element: Element) -> SharedSequence<SharingStrategy, Bool> {
    map { $0 == element }
  }

  func isNotEqual(to element: Element) -> SharedSequence<SharingStrategy, Bool> {
    map { $0 != element }
  }
}
