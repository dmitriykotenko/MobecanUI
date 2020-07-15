//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension ObservableType {
  
  func weakFlatMap<Parent: AnyObject, Property>(
    _ parent: Parent,
    _ transform: @escaping (Element, Parent) -> Observable<Property>) -> Observable<Property> {
    
    flatMap { [weak parent] element in
      parent.map { transform(element, $0) } ?? .never()
    }
  }
  
  func weakFlatMapLatest<Parent: AnyObject, Property>(
    _ parent: Parent,
    _ transform: @escaping (Element, Parent) -> Observable<Property>) -> Observable<Property> {
    
    flatMapLatest { [weak parent] element in
      parent.map { transform(element, $0) } ?? .never()
    }
  }
}
