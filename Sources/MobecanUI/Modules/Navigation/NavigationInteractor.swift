// Copyright © 2020 Mobecan. All rights reserved.

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

    disposeBag {
      _modules.debug("Navigation-Modules").subscribe()
      _events.debug("Navigation-Event").subscribe()
    }
  }
  
  private func setupPushes() {
    disposeBag {
      _events.asObservable()
        .pushes
        .do(onNext: { [weak self] in self?.listen(module: $0) })
        .withLatestFrom(_modules) { $1 + [$0] }
        .debug("Navigation-Desired-Modules")
        ==> _desiredModules
    }
  }
  
  private func setupPops() {
    disposeBag {
      _pop.map { .pop } ==> events

      _events.asObservable()
        .pops
        .withLatestFrom(_modules)
        .map { $0.dropLast() }
        .debug("Navigation-Desired-Modules")
        ==> _desiredModules
    }
  }
  
  private func setupPopsTo() {
    disposeBag {
      _popTo.map { .popTo($0) } ==> events

      _events.asObservable()
        .popsTo
        .withLatestFrom(_modules) { moduleType, modules in
          modules.prefixUpTo(moduleType: moduleType)
        }
        .debug("Navigation-Desired-Modules")
        ==> _desiredModules
    }
  }

  private func listen(module: Module) {
    let moduleEvents = listeners.lazy.compactMap { $0.segues(module: module) }.first

    disposeBag {
      (moduleEvents ?? .empty()) ==> events
    }
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
