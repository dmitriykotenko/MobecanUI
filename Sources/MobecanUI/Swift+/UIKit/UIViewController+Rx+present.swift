//  Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public extension Reactive where Base: UIViewController {

  func present(_ viewController: UIViewController,
               animated: Bool) -> Single<Void> {
    let subject = AsyncSubject<Void>()

    base.present(
      viewController,
      animated: animated,
      completion: { subject.onNext(()); subject.onCompleted() }
    )

    return subject.asSingle()
  }

  func dismiss(animated: Bool) -> Single<Void> {
    let subject = AsyncSubject<Void>()

    base.dismiss(
      animated: animated,
      completion: { subject.onNext(()); subject.onCompleted() }
    )

    return subject.asSingle()
  }
}
