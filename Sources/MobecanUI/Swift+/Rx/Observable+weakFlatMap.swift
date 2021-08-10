//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension ObservableType {
  
  func weakFlatMap<Parent: AnyObject, Source: ObservableConvertibleType>(
    _ parent: Parent,
    _ transform: @escaping (Element, Parent) -> Source) -> Observable<Source.Element> {
    
    flatMap { [weak parent] element in
      parent.map { transform(element, $0).asObservable() } ?? .never()
    }
  }
  
  func weakFlatMapLatest<Parent: AnyObject, Source: ObservableConvertibleType>(
    _ parent: Parent,
    _ transform: @escaping (Element, Parent) -> Source) -> Observable<Source.Element> {
    
    flatMapLatest { [weak parent] element in
      parent.map { transform(element, $0).asObservable() } ?? .never()
    }
  }
}


public extension PrimitiveSequenceType where Trait == SingleTrait {

  func weakFlatMap<Parent: AnyObject, Property>(
    _ parent: Parent,
    _ transform: @escaping (Element, Parent) -> Single<Property>) -> Single<Property> {

    flatMap { [weak parent] element in
      parent.map { transform(element, $0) } ?? .never()
    }
  }
}
