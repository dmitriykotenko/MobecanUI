//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


open class ListModule<Query, Element, ElementEvent, SomeError: Error>: Module {

  open var elementEvent: Observable<ElementEvent> { interactor.unhandledElementEvents }
  open var finished: Observable<Void> { .never() }
  
  open var viewController: UIViewController { view }

  public let interactor: ListInteractor<Query, Element, ElementEvent, SomeError>
  public let presenter: ListPresenter<Query, Element, ElementEvent, SomeError>
  public let view: ListViewController<Query, Element, ElementEvent>

  public init(interactor: ListInteractor<Query, Element, ElementEvent, SomeError>,
              presenter: ListPresenter<Query, Element, ElementEvent, SomeError>,
              view: ListViewController<Query, Element, ElementEvent>) {
    self.interactor = interactor
    self.presenter = presenter
    self.view = view

    presenter.setInteractor(interactor)
    view.setPresenter(presenter)
  }
}
