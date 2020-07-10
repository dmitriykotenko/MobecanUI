//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


open class ListModule<Query, Element, ElementEvent, SomeError: Error>: Module {
  
  public struct Parts {
    public let interactor: ListInteractor<Query, Element, ElementEvent, SomeError>
    public let presenter: ListPresenter<Query, Element, ElementEvent, SomeError>
    public let view: ListViewController<Query, Element, ElementEvent>
  }

  open var elementEvent: Observable<ElementEvent> { interactor.unhandledElementEvents }
  open var finished: Observable<Void> { .never() }
  
  open var viewController: UIViewController { view }

  public let interactor: ListInteractor<Query, Element, ElementEvent, SomeError>
  public let presenter: ListPresenter<Query, Element, ElementEvent, SomeError>
  public let view: ListViewController<Query, Element, ElementEvent>
  
  public var demonstrator: Demonstrator?

  public convenience init(parts: Parts) {
    self.init(parts: parts, demonstrator: nil)
  }

  public init(parts: Parts,
              demonstrator: Demonstrator?) {
    self.interactor = parts.interactor
    self.presenter = parts.presenter
    self.view = parts.view
    
    self.demonstrator =
      demonstrator ??
      UiKitDemonstrator(parentViewController: parts.view)

    presenter.setInteractor(interactor)
    view.setPresenter(presenter)
  }
}
