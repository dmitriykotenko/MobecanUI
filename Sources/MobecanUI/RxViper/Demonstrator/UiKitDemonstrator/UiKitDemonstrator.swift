// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public class UiKitDemonstrator: Demonstrator {

  @RxSignalOutput public var demonstrationFinished: Signal<Module>

  private let parentViewController: UIViewController
  private let wrapper: (UIViewController) -> UIViewController
  private let animating: Bool

  private var currentDemonstration: Demonstration?

  private var disposeBag = DisposeBag()

  public init(parentViewController: UIViewController,
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
    // Reset disposeBag to ignore subsequent 'needsToBeFinished' events from previous demonstration.
    disposeBag = DisposeBag()

    return finishCurrentDemonstration().weakFlatMap(self) {
      $1.present(module: module, animating: animating)
    }
  }

  private func finishCurrentDemonstration(animating: Bool = false) -> Single<Void> {
    currentDemonstration?.canBeFinished
      .weakFlatMap(self) { $1.finishCurrentDemonstrationImmediately(animating: animating) }
      ?? .just(())
  }

  private func present(module: Module,
                       animating: Bool?) -> Single<Void> {
    let demonstration = createDemonstration(
      module: module,
      animating: animating ?? self.animating
    )

    // FIXME: temporary hack to completely avoid autolayout constraints creation
    demonstration.containerViewController.enableFullScreenPresentation()

    return parentViewController.rx.present(
      demonstration.containerViewController,
      animated: animating ?? self.animating
    )
  }

  private func createDemonstration(module: Module,
                                   animating: Bool) -> Demonstration {
    let demonstration = Demonstration(module: module)

    disposeBag {
      demonstration.needsToBeFinished
        .weakFlatMap(self) { $1.finishCurrentDemonstrationImmediately(animating: animating) }
        .subscribe()
    }

    currentDemonstration = demonstration

    return demonstration
  }

  private func finishCurrentDemonstrationImmediately(animating: Bool = false) -> Single<Void> {
    guard isDemonstrating else { return .just(()) }

    return Single.if(
      // Do not perform dismission if there is nothing to dismiss.
      // Otherwise, parentViewController can accidentally dismiss itself
      // (see UIViewController.dismiss(animated:completion:) method reference).
      parentViewController.presentedViewController != nil,
      then: parentViewController.rx.dismiss(animated: animating),
      else: .just(())
    )
    .do(onSuccess: { [weak self] in self?.onDemonstrationFinished() })
  }

  private var isDemonstrating: Bool { currentDemonstration != nil }

  private func onDemonstrationFinished() {
    currentDemonstration.map {
      _demonstrationFinished.onNext($0.module)
    }

    currentDemonstration = nil
  }
}
