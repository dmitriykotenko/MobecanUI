// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public extension ObservableType {
  
  func neverEnding() -> Observable<Element> {
    Observable.concat(self.asObservable(), .never())
  }
}
