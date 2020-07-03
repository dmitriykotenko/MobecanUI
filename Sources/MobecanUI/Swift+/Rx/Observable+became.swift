//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public extension ObservableType {

  func became(_ comparison: @escaping (Element, Element) -> Bool) -> Observable<(Element, Element)> {
    withPrevious()
      .filter { comparison($0, $1) }
  }

  /// Every time the value becomes nil, emits last non-nil value.
  func becameNil<NestedElement>() -> Observable<Element> where Element == NestedElement? {
    withPrevious()
      .filter { $0 != nil && $1 == nil }.map { $0.0 }
  }

  func becameNotNil<NestedElement>(includeInitialValue: Bool)
    -> Observable<Element> where Element == NestedElement? {

      let initialValue = includeInitialValue ? take(1).filter { $0 != nil } : Observable.empty()
      
      return Observable.merge(
        initialValue,
        withPrevious().filter { $0 == nil && $1 != nil }.map { $0.1 }
      )
  }
}
