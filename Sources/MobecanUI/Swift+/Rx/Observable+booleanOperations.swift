//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public extension ObservableType where Element == Bool {
  
  func and<ThatObservableType: ObservableType>(that: ThatObservableType) -> Observable<Bool>
    where ThatObservableType.Element == Bool {

      return Observable.combineLatest(self, that) { $0 && $1 }
  }
  
  func or<ThatObservableType: ObservableType>(that: ThatObservableType) -> Observable<Bool>
    where ThatObservableType.Element == Bool {
      
      return Observable.combineLatest(self, that) { $0 || $1 }
  }
  
  func not() -> Observable<Bool> {      
    return map { !$0 }
  }
}
