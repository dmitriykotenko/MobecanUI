// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxOptional
import RxSwift


public extension Observable where Element: OptionalType {
  
  func nestedMap<T>(_ transform: @escaping (Element.Wrapped) -> T) -> Observable<T?> {
    map {
      $0.value.map(transform)
    }
  }
  
  func nestedFlatMap<T>(_ transform: @escaping (Element.Wrapped) -> T?) -> Observable<T?> {
    map {
      $0.value.flatMap(transform)
    }
  }
}


public extension SharedSequenceConvertibleType where Element: OptionalType {
  
  func nestedMap<T>(_ transform: @escaping (Element.Wrapped) -> T) -> SharedSequence<SharingStrategy, T?> {
    map {
      $0.value.map(transform)
    }
  }
  
  func nestedFlatMap<T>(_ transform: @escaping (Element.Wrapped) -> T?) -> SharedSequence<SharingStrategy, T?> {
    map {
      $0.value.flatMap(transform)
    }
  }
}


public extension PrimitiveSequenceType where Trait == SingleTrait, Element: OptionalType {

  func nestedMap<T>(_ transform: @escaping (Element.Wrapped) -> T) -> Single<T?> {
    map {
      $0.value.map(transform)
    }
  }

  func nestedFlatMap<T>(_ transform: @escaping (Element.Wrapped) -> T?) -> Single<T?> {
    map {
      $0.value.flatMap(transform)
    }
  }
}
