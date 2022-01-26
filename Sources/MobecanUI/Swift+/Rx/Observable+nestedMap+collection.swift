// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxOptional
import RxSwift


public extension Observable where Element: Collection {
  
  func nestedMap<T>(transform: @escaping (Element.Element) -> T) -> Observable<[T]> {
    map { collection in
      collection.map(transform)
    }
  }
}


public extension SharedSequenceConvertibleType where Element: Collection {
  
  func nestedMap<T>(transform: @escaping (Element.Element) -> T) -> SharedSequence<SharingStrategy, [T]> {
    map { collection in
      collection.map(transform)
    }
  }
}


public extension PrimitiveSequenceType where Trait == SingleTrait, Element: Collection {

  func nestedMap<T>(transform: @escaping (Element.Element) -> T) -> Single<[T]> {
    map { collection in
      collection.map(transform)
    }
  }
}
