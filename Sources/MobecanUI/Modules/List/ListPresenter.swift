// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public protocol ListPresenterProtocol {
  
  associatedtype Query
  associatedtype Element
  associatedtype ElementEvent
  associatedtype SomeError: Error
  
  var title: Driver<String> { get }
  var sections: Driver<[SimpleTableViewSection<Element>]> { get }
  
  var elementEvents: AnyObserver<ElementEvent> { get }
}


open class ListPresenter<Query, Element, ElementEvent, SomeError: Error>: ListPresenterProtocol {

  @RxDriverOutput("") public var title: Driver<String>
  @RxDriverOutput([]) public var sections: Driver<[SimpleTableViewSection<Element>]>
  @RxInput public var elementEvents: AnyObserver<ElementEvent>
  
  private let sectionsBuilder: (Loadable<[Element], SomeError>) -> [SimpleTableViewSection<Element>]
  
  public init(title: Observable<String>,
              sectionsBuilder: @escaping (Loadable<[Element], SomeError>) -> [SimpleTableViewSection<Element>]) {
    self.sectionsBuilder = sectionsBuilder

    disposeBag { title ==> _title }
  }

  private let disposeBag = DisposeBag()

  open func setInteractor<Interactor: ListInteractorProtocol>(_ interactor: Interactor)
  where
  Interactor.Query == Query,
  Interactor.Element == Element,
  Interactor.ElementEvent == ElementEvent,
  Interactor.SomeError == SomeError {

    disposeBag {
      _sections <==
        interactor.elements.map { [sectionsBuilder] in sectionsBuilder($0) }

      _elementEvents ==> interactor.elementEvents
    }
  }
}
