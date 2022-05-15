// Copyright © 2022 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public extension ObservableType {
  
  func filterNot(_ condition: @escaping (Element) -> Bool) -> Observable<Element> {
    filter { condition($0) == false }
  }
}


public extension SharedSequenceConvertibleType {

  func filterNot(_ condition: @escaping (Element) -> Bool) -> SharedSequence<SharingStrategy, Element> {
    filter { condition($0) == false }
  }
}
