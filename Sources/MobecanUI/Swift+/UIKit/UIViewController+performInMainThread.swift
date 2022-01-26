// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public extension UIViewController {
  
  func performInMainThread<Value>(_ code: @escaping () -> Value) -> Single<Value> {
    let subject = AsyncSubject<Value>()

    if Thread.isMainThread {
      subject.onNext(code())
      subject.onCompleted()
    } else {
      DispatchQueue.main.async {
        subject.onNext(code())
        subject.onCompleted()
      }
    }
    
    return subject.asSingle()
  }
}
