// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension ObservableType {
  
  func weakMap<Parent: AnyObject, OtherElement>(
    _ parent: Parent,
    _ transform: @escaping (Element, Parent) -> OtherElement) -> Observable<OtherElement> {

    weakFlatMap(parent) { Observable.just(transform($0, $1)) }
  }
}


public extension PrimitiveSequenceType where Trait == SingleTrait {

  func weakMap<Parent: AnyObject, OtherElement>(
    _ parent: Parent,
    _ transform: @escaping (Element, Parent) -> OtherElement) -> Single<OtherElement> {

    weakFlatMap(parent) { .just(transform($0, $1)) }
  }
}
