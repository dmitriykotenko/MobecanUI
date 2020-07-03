//  Copyright © 2020 Mobecan. All rights reserved.


import RxOptional
import RxSwift


public extension ObservableType {
  
  func filterWith<Filter: ObservableConvertibleType>(_ filter: Filter) -> Observable<Element>
    where Filter.Element == Bool {
      
      withLatestFrom(filter) { ($0, $1) }
        .filter { $0.1 == true }
        .map { $0.0 }
  }
  
  func filterWithNot<Filter: ObservableConvertibleType>(_ filter: Filter) -> Observable<Element>
    where Filter.Element == Bool {
      
      withLatestFrom(filter) { ($0, $1) }
        .filter { $0.1 == false }
        .map { $0.0 }
  }
  
  func filterWithLatestFrom<That: ObservableConvertibleType>(_ that: That,
                                                             predicate: @escaping (Element, That.Element) -> Bool)
    -> Observable<Element> {
      
      withLatestFrom(that) { ($0, $1) }
        .filter { predicate($0.0, $0.1) }
        .map { $0.0 }
  }
}
