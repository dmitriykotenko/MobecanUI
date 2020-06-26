//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


public protocol ListInteractorProtocol {
  
  associatedtype Query
  associatedtype Element
  associatedtype ElementEvent
  associatedtype SomeError: Error

  var elements: Observable<Loadable<[Element], SomeError>> { get }
  
  var load: AnyObserver<Query> { get }
  var elementEvents: AnyObserver<ElementEvent> { get }
}


open class ListInteractor<Query, Element, ElementEvent, SomeError: Error>: ListInteractorProtocol {
  
  @RxOutput(.isLoading) public var elements: Observable<Loadable<[Element], SomeError>>
  @RxOutput public var unhandledElementEvents: Observable<ElementEvent>
  
  @RxInput public var load: AnyObserver<Query>
  @RxInput public var elementEvents: AnyObserver<ElementEvent>

  private let loader: (Query) -> Single<Result<[Element], SomeError>>
  private let eventHandler: (ElementEvent) -> Bool
  
  private let disposeBag = DisposeBag()

   public init<Loader: ListLoader>(loader: Loader,
                                   eventHandler: @escaping (ElementEvent) -> Bool)
    where Loader.Query == Query, Loader.Element == Element, Loader.SomeError == SomeError {
      
      self.loader = { loader.load($0) }
      self.eventHandler = eventHandler
      
      let loadingStarted = _load
      let loadingFinished = _load.flatMapLatest { loader.load($0) }
      
      Observable
        .merge(loadingStarted.map { _ in .isLoading }, loadingFinished.map { .loaded($0) })
        .bind(to: _elements)
        .disposed(by: disposeBag)
      
      _elementEvents
        .compactMap { eventHandler($0) ? nil : $0 }
        .bind(to: _unhandledElementEvents)
        .disposed(by: disposeBag)
  }
}
