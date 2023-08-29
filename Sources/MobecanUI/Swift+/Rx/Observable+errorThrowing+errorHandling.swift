// Copyright © 2023 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension Observable {

  func `if`(_ condition: @escaping (Element) -> Bool,
            throw error: @escaping (Element) -> Error) -> Observable {
    map {
      if condition($0) { throw error($0) }
      return $0
    }
  }

  func ifNot(_ condition: @escaping (Element) -> Bool,
             throw error: @escaping (Element) -> Error) -> Observable {
    map {
      if !condition($0) { throw error($0) }
      return $0
    }
  }

  func ifErrorCatched(_ errorCondition: @escaping (Error) -> Bool,
                      return that: @escaping (Error) -> Observable) -> Observable {
    self.catch { error in
      if errorCondition(error) {
        return that(error)
      } else {
        return .error(error)
      }
    }
  }

  func ifErrorCatched(_ errorCondition: @escaping (Error) -> Bool,
                      return that: @autoclosure @escaping () -> Observable) -> Observable {
    ifErrorCatched(
      errorCondition,
      return: { _ in that() }
    )
  }
}


public extension PrimitiveSequenceType where Trait == SingleTrait {

  func `if`(_ condition: @escaping (Element) -> Bool,
            throw error: @escaping (Element) -> Error) -> Single<Element> {
    map {
      if condition($0) { throw error($0) }
      return $0
    }
  }

  func ifNot(_ condition: @escaping (Element) -> Bool,
             throw error: @escaping (Element) -> Error) -> Single<Element> {
    map {
      if !condition($0) { throw error($0) }
      return $0
    }
  }
}
