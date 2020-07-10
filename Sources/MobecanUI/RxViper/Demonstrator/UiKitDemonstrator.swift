//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public class UiKitDemonstrator: Demonstrator {
  
  @RxOutput var demonstrationFinished: Observable<Module>
  
  private let parentViewController: UIViewController
  private let wrapper: (UIViewController) -> UIViewController
  private let animating: Bool
  
  private var demonstratedModule: Module?
  
  private let disposeBag = DisposeBag()

  init(parentViewController: UIViewController,
       wrapper: @escaping (UIViewController) -> UIViewController = { $0 },
       animating: Bool = true) {
    self.parentViewController = parentViewController
    self.wrapper = wrapper
    self.animating = animating
  }
  
  public func demonstrate(module: Module) -> Single<Void> {
    demonstrate(module: module, animating: animating)
  }

  public func demonstrate(module: Module,
                          animating: Bool?) -> Single<Void> {    
    let stopping =
      demonstratedModule.map { stopDemonstration(of: $0) } ?? Single.just(())
    
    return stopping
      .flatMap { [weak self] in
        self.map {
          $0.present(
            module: module,
            animating: animating ?? $0.animating
          )
        } ?? .just(())
      }
  }
  
  private func present(module: Module,
                       animating: Bool) -> Single<Void> {
    demonstratedModule = module
    
    module.finished
      .flatMap { [weak self] in
        self?.stopDemonstration(of: module, animating: animating) ?? .just(())
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    let subject = AsyncSubject<Void>()
    
    parentViewController.present(
      wrapper(module.viewController),
      animated: animating,
      completion: { subject.onNext(()); subject.onCompleted() }
    )
    
    return subject.asSingle()
  }
  
  private func stopDemonstration(of module: Module,
                                 animating: Bool = false) -> Single<Void> {
    let subject = AsyncSubject<Void>()
    
    parentViewController.dismiss(
      animated: animating,
      completion: { [weak self] in
        self?.demonstratedModule = nil
        self?._demonstrationFinished.onNext(module)
        subject.onNext(())
        subject.onCompleted()
      }
    )
    
    return subject.asSingle()
  }
}
