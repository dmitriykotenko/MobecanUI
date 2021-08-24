//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


public protocol NavigationInteractorProtocol {
  
  var desiredModules: Observable<[Module]> { get }
  var dismiss: Observable<Void> { get }
  
  var modules: AnyObserver<[Module]> { get }
  var pop: AnyObserver<Void> { get }
  var popTo: AnyObserver<Module.Type> { get }
  var userWantsToCloseNavigationController: AnyObserver<Void> { get }
}


public class NavigationInteractor: NavigationInteractorProtocol {
  
  @RxOutput([]) public var desiredModules: Observable<[Module]>
  @RxOutput public var dismiss: Observable<Void>
  
  @RxInput([]) public var modules: AnyObserver<[Module]>
  @RxInput public var pop: AnyObserver<Void>
  @RxInput public var popTo: AnyObserver<Module.Type>
  @RxInput public var userWantsToCloseNavigationController: AnyObserver<Void>

  @RxInput public var events: AnyObserver<NavigationEvent>
  
  public var topModule: Observable<Module?> { _modules.map { $0.last } }
  public var rootModule: Observable<Module?> { _modules.map { $0.first } }

  private let listeners: [NavigationSegues]
  
  private let disposeBag = DisposeBag()

  public init(listeners: [NavigationSegues]) {
    self.listeners = listeners
    
    setupPushes()
    setupPops()
    setupPopsTo()

    [
      _modules.debug("Navigation-Modules").subscribe(),
      _events.debug("Navigation-Event").subscribe()
    ]
    .disposed(by: disposeBag)
  }
  
  private func setupPushes() {
    _events.asObservable()
      .pushes
      .do(onNext: { [weak self] in self?.listen(module: $0) })
      .withLatestFrom(_modules) { $1 + [$0] }
      .debug("Navigation-Desired-Modules")
      .bind(to: _desiredModules)
      .disposed(by: disposeBag)
  }
  
  private func setupPops() {
    _pop
      .map { .pop }
      .bind(to: events)
      .disposed(by: disposeBag)
    
    _events.asObservable()
      .pops
      .withLatestFrom(_modules)
      .map { $0.dropLast() }
      .debug("Navigation-Desired-Modules")
      .bind(to: _desiredModules)
      .disposed(by: disposeBag)
  }
  
  private func setupPopsTo() {
    _popTo
      .map { .popTo($0) }
      .bind(to: events)
      .disposed(by: disposeBag)
    
    _events.asObservable()
      .popsTo
      .withLatestFrom(_modules) { moduleType, modules in
        modules.prefixUpTo(moduleType: moduleType)
      }
      .debug("Navigation-Desired-Modules")
      .bind(to: _desiredModules)
      .disposed(by: disposeBag)
  }

  private func listen(module: Module) {
    let moduleEvents = listeners.lazy.compactMap { $0.segues(module: module) }.first
    
    moduleEvents?
      .bind(to: events)
      .disposed(by: disposeBag)
  }
  
  public func setRootModule(_ module: Module) {
    events.onNext(.push(module))
  }
}


private extension Array where Element == Module {
  
  func prefixUpTo(moduleType: Module.Type) -> [Element] {
    prefixUpTo { module in type(of: module) == moduleType }
  }
}
