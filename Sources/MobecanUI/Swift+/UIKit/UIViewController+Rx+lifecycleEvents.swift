//  Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public extension Reactive where Base: UIViewController {

  /// Fires immediately after 'viewDidLoad()' method was finished.
  var viewDidLoad: Observable<Void> {
    methodInvoked(#selector(UIViewController.viewDidLoad)).mapToVoid()
  }

  /// Fires immediately after 'viewWillAppear()' method was finished.
  var viewWillAppear: Observable<Bool> {
    methodInvoked(#selector(UIViewController.viewWillAppear(_:))).compactMap {
      $0.first as? Bool
    }
  }

  /// Fires immediately after 'viewDidAppear()' method was finished.
  var viewDidAppear: Observable<Bool> {
    methodInvoked(#selector(UIViewController.viewDidAppear(_:))).compactMap {
      $0.first as? Bool
    }
  }

  /// Fires immediately after 'viewWillDisappear()' method was finished.
  var viewWillDisappear: Observable<Bool> {
    methodInvoked(#selector(UIViewController.viewWillDisappear(_:))).compactMap {
      $0.first as? Bool
    }
  }

  /// Fires immediately after 'viewDidDisappear()' method was finished.
  var viewDidDisappear: Observable<Bool> {
    methodInvoked(#selector(UIViewController.viewDidDisappear(_:))).compactMap {
      $0.first as? Bool
    }
  }

  /// Fires immediately after 'viewWillLayoutSubviews()' method was finished.
  var viewWillLayoutSubviews: Observable<Void> {
    methodInvoked(#selector(UIViewController.viewWillLayoutSubviews)).mapToVoid()
  }

  /// Fires immediately after 'viewDidLayoutSubviews()' method was finished.
  var viewDidLayoutSubviews: Observable<Void> {
    methodInvoked(#selector(UIViewController.viewDidLayoutSubviews)).mapToVoid()
  }

  /// Fires immediately after 'willMoveToParent()' method was finished.
  var willMoveToParent: Observable<UIViewController?> {
    methodInvoked(#selector(UIViewController.willMove(toParent:))).compactMap {
      $0.first as? UIViewController?
    }
  }

  /// Fires immediately after 'didMoveToParent()' method was finished.
  var didMoveToParent: Observable<UIViewController?> {
    methodInvoked(#selector(UIViewController.didMove(toParent:))).compactMap {
      $0.first as? UIViewController?
    }
  }
}
