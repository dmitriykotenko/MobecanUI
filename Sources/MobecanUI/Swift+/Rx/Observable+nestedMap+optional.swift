//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxOptional
import RxSwift


public extension Observable where Element: OptionalType {
  
  func nestedMap<T>(transform: @escaping (Element.Wrapped) -> T) -> Observable<T?> {
    map {
      $0.value.map(transform)
    }
  }
  
  func nestedFlatMap<T>(transform: @escaping (Element.Wrapped) -> T?) -> Observable<T?> {
    map {
      $0.value.flatMap(transform)
    }
  }
}


public extension SharedSequenceConvertibleType where Element: OptionalType {
  
  func nestedMap<T>(transform: @escaping (Element.Wrapped) -> T) -> SharedSequence<SharingStrategy, T?> {
    map {
      $0.value.map(transform)
    }
  }
  
  func nestedFlatMap<T>(transform: @escaping (Element.Wrapped) -> T?) -> SharedSequence<SharingStrategy, T?> {
    map {
      $0.value.flatMap(transform)
    }
  }
}
