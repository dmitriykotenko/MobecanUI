// Copyright © 2020 Mobecan. All rights reserved.

import MobecanUI
import RxCocoa
import RxSwift
import UIKit


public class Loading<Query, Value, SomeError: Error>: ObservableType {

  public let loadable: Observable<Loadable<Value, SomeError>>

  public typealias Element = Loadable<Value, SomeError>

  public init(query: Query,
              load: @escaping (Query) -> Single<Result<Value, SomeError>>) {

    loadable = Observable
      .just(.isLoading)
      .concat(load(query).map { .loaded($0) })
  }

  public func subscribe<Observer>(_ observer: Observer) -> Disposable
  where Observer: ObserverType, Element == Observer.Element {

    loadable.subscribe(observer)
  }
}
