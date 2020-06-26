//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


public protocol ListLoader {
  
  associatedtype Query
  associatedtype Element
  associatedtype SomeError: Error

  func load(_ context: Query) -> Single<Result<[Element], SomeError>>
}


public struct FunctionalListLoader<Query, Element, SomeError: Error>: ListLoader {
  
  private let loader: (Query) -> Single<Result<[Element], SomeError>>
  
  public init(loader: @escaping (Query) -> Single<Result<[Element], SomeError>>) {
    self.loader = loader
  }
  
  public static func immediate(elements: [Element]) -> FunctionalListLoader {
    return .init { _ in .just(.success(elements)) }
  }
  
  public func load(_ context: Query) -> Single<Result<[Element], SomeError>> {
    return loader(context)
  }
}
