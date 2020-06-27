//  Copyright © 2020 Mobecan. All rights reserved.

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
    interactor.desiredModules
      .do(onNext: { [weak self] in self?.makeSnapshot($0) })
      .map { modules in (modules.map { $0.viewController }, true) }
      .bind(to: _events)
      .disposed(by: disposeBag)

    _viewControllers
      .map { [weak self] viewControllers in viewControllers.compactMap { self?.modulesSnapshot[$0] } }
      .bind(to: interactor.modules)
      .disposed(by: disposeBag)
    
    _backButtonTap
      .withLatestFrom(_viewControllers)
      .filter { $0.count > 1 }
      .mapToVoid()
      .bind(to: interactor.pop)
      .disposed(by: disposeBag)
    
    _backButtonTap
      .withLatestFrom(_viewControllers)
      .filter { $0.count <= 1 }
      .mapToVoid()
      .bind(to: interactor.userWantsToCloseNavigationController)
      .disposed(by: disposeBag)
  }
  
  private func makeSnapshot(_ newModules: [Module]) {
    modulesSnapshot = Dictionary(uniqueKeysWithValues: newModules.map { ($0.viewController, $0) })
  }
}
