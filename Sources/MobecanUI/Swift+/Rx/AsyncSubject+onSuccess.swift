// Copyright © 2021 Mobecan. All rights reserved.

import RxSwift


public extension AsyncSubject {

  func onSuccess(_ element: Element) {
    onNext(element)
    onCompleted()
  }
}
