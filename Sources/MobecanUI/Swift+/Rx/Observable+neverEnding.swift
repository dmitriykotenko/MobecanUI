//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public extension Observable {
  
  func neverEnding() -> Observable<Element> {
    Observable.concat(self, .never())
  }
}
