// Copyright © 2021 Mobecan. All rights reserved.

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
          .observe(on: MainScheduler.asyncInstance)
          .take(1)
          .asSingle() :
        .just(())
    }

    var needsToBeFinished: Observable<Void> {
      .merge(
        module.finished
          .observe(on: MainScheduler.instance)
          // Если пользователь совсем недавно инициировал автоматическое скрытие экрана
          // (например, свайпнув вниз), ждём неизбежного события .rxViewDidDismiss
          // от containerViewController.
          .filter { !containerViewController.isBeingDismissed }
          // Задержка, чтобы правильно обработать слишком ранние сигналы 'module.finished'.
          .wait(for: containerViewController.rxViewDidAppear.map { true }),
        containerViewController.rxViewDidDismiss.asObservable()
      )
      .take(1)
    }
  }
}
