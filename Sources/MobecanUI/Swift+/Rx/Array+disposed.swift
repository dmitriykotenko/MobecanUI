// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


public extension Array where Element == Disposable {
  
  func disposed(by disposeBag: DisposeBag) {
    forEach { $0.disposed(by: disposeBag) }
  }
}
