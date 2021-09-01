//  Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


extension UiKitDemonstrator {

  struct Demonstration {

    var module: Module
    var containerViewController: LifecycleBroadcasterViewController

    init(module: Module) {
      self.module = module
      self.containerViewController = .init(child: module.viewController)
    }

    var canBeFinished: Single<Void> {
      containerViewController.isBeingDismissed ?
        containerViewController.rxViewDidDisappear
          .asObservable()
          .observeOn(MainScheduler.asyncInstance)
          .take(1)
          .asSingle() :
        .just(())
    }

    var needsToBeFinished: Observable<Void> {
      .merge(
        module.finished
          // If the user has recently initiated automatic dismissal
          // (by swipe-down gesture or by other means), wait for inevitable .rxViewDidDismiss signal
          // from containerViewController.
          .filter { !containerViewController.isBeingDismissed }
          // Delay too early 'module.finished' signals.
          .wait(for: containerViewController.rxViewDidAppear.map { true })
          .observeOn(MainScheduler.instance),
        containerViewController.rxViewDidDismiss.asObservable()
      )
      .take(1)
    }
  }
}
