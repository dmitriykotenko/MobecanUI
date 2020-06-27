//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


public extension Observable {

  func nilIf<T>(_ predicate: Observable<Bool>) -> Observable<T?> where T? == Element {
    return Observable.combineLatest(predicate, self) { $0 ? nil : $1 }
  }

  func nilIfNot<T>(_ predicate: Observable<Bool>) -> Observable<T?> where T? == Element {
    return nilIf(predicate.map { !$0 })
  }

  func nilIf(_ predicate: Observable<Bool>) -> Observable<Element?> {
    let optionalSelf: Observable<Element?> = map { $0 }
    
    return optionalSelf.nilIf(predicate)
  }
  
  func nilIfNot(_ predicate: Observable<Bool>) -> Observable<Element?> {
    let optionalSelf: Observable<Element?> = map { $0 }
    
    return optionalSelf.nilIfNot(predicate)
  }
}
