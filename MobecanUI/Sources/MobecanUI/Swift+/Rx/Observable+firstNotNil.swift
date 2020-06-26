//  Copyright © 2020 Mobecan. All rights reserved.


import RxOptional
import RxSwift


public extension ObservableType {
  
  func firstNotNilValue<NestedElement>() -> Single<NestedElement> where Element == NestedElement? {
    return filterNil().take(1).asSingle()
  }
}
