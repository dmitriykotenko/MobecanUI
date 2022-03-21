// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public class PushDemonstrator: Demonstrator {
  
  private let parentViewController: NavigationController
  private let animating: Bool
  
  private var demonstratedModule: Module?
  
  private let disposeBag = DisposeBag()
  
  init(parentViewController: NavigationController,
       animating: Bool) {
    self.parentViewController = parentViewController
    self.animating = animating
  }
  
  public func demonstrate(module: Module) -> Single<Void> {
    demonstrate(module: module, animating: animating)
  }
  
  public func demonstrate(module: Module,
                          animating: Bool?) -> Single<Void> {
    present(
      module: module,
      animating: animating ?? self.animating
    )
  }
  
  private func present(module: Module,
                       animating: Bool) -> Single<Void> {
    demonstratedModule = module

    disposeBag {
      module.finished
        .observe(on: MainScheduler.instance)
        .flatMap { [weak self] in
          self?.stopDemonstration(of: module, animating: animating) ?? .just(())
        }
        .subscribe()
    }

    let result = parentViewController.viewControllers
      .filter { $0.contains(module.viewController) }
      .take(1)
      .mapToVoid()
      .asSingle()
    
    parentViewController.push(module.viewController, animated: animating)
    
    return result
  }
  
  private func stopDemonstration(of module: Module,
                                 animating: Bool = false) -> Single<Void> {
    let result = parentViewController.viewControllers
      .filter { !$0.contains(module.viewController) }
      .take(1)
      .mapToVoid()
      .asSingle()

    disposeBag {
      parentViewController.viewControllers
        .take(1)
        .map { Array($0.drop { $0 != module.viewController }) }
        ==> { [weak self] in self?.parentViewController.set(children: $0, animated: animating) }
    }

    return result
  }
}
