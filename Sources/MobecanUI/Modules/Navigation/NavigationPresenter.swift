// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public protocol NavigationPresenterProtocol {
  
  var events: Signal<([UIViewController], Bool)> { get }

  var viewControllers: AnyObserver<[UIViewController]> { get }
  var backButtonTap: AnyObserver<Void> { get }
}


public class NavigationPresenter: NavigationPresenterProtocol {
  
  @RxSignalOutput public var events: Signal<([UIViewController], Bool)>
  
  @RxInput([]) public var viewControllers: AnyObserver<[UIViewController]>
  @RxInput public var backButtonTap: AnyObserver<Void>
  
  private var modulesSnapshot: [UIViewController: Module] = [:]

  private let disposeBag = DisposeBag()
  
  public init() {}

  public func setInteractor(_ interactor: NavigationInteractorProtocol) {
    disposeBag {
      interactor.desiredModules
        .do(onNext: { [weak self] in self?.makeSnapshot($0) })
        .map { modules in (modules.map { $0.viewController }, true) }
        ==> _events

      _viewControllers
        .map { [weak self] viewControllers in viewControllers.compactMap { self?.modulesSnapshot[$0] } }
        ==> interactor.modules

      _backButtonTap
        .filterWith(_viewControllers.map { $0.count > 1 })
        ==> interactor.pop

      _backButtonTap
        .filterWith(_viewControllers.map { $0.count <= 1 })
        ==> interactor.userWantsToCloseNavigationController
    }
  }
  
  private func makeSnapshot(_ newModules: [Module]) {
    modulesSnapshot = Dictionary(uniqueKeysWithValues: newModules.map { ($0.viewController, $0) })
  }
}
