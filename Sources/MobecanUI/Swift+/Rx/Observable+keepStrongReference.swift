// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public extension Observable {
  
  func keepStrongReference<T>(to object: T) -> Observable<Element> {
    map { ($0, object).0 }
  }
}
