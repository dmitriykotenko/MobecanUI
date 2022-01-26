// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


public protocol ListLoader {
  
  associatedtype Query
  associatedtype Element
  associatedtype SomeError: Error

  func load(_ query: Query) -> Single<Result<[Element], SomeError>>
}


public struct FunctionalListLoader<Query, Element, SomeError: Error>: ListLoader {
  
  private let privateLoad: (Query) -> Single<Result<[Element], SomeError>>
  
  public init(load: @escaping (Query) -> Single<Result<[Element], SomeError>>) {
    self.privateLoad = load
  }
  
  public static func immediate(elements: [Element]) -> FunctionalListLoader {
    .init { _ in .just(.success(elements)) }
  }
  
  public func load(_ query: Query) -> Single<Result<[Element], SomeError>> {
    privateLoad(query)
  }
}
