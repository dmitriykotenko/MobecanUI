// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public class NavigationModule {
  
  public var events: AnyObserver<NavigationEvent> { interactor.events }
  
  public var topModule: Observable<Module?> { interactor.topModule }
  public var rootModule: Observable<Module?> { interactor.rootModule }
  public var dismiss: Observable<Void> { interactor.dismiss }
  
  public var viewController: UIViewController { view }

  private let interactor: NavigationInteractor
  private let presenter: NavigationPresenter
  private let view: NavigationViewController
  
  private let disposeBag = DisposeBag()

  public init(interactor: NavigationInteractor,
              presenter: NavigationPresenter,
              view: NavigationViewController) {
    self.interactor = interactor
    self.presenter = presenter
    self.view = view

    presenter.setInteractor(interactor)
    view.setPresenter(presenter)
  }
  
  public func setRootModule(_ rootModule: Module) {
    interactor.setRootModule(rootModule)
  }
}
