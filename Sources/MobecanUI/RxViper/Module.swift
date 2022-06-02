// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


/// One of application's screens.
public protocol Module {

  /// View-controller with screen's content.
  var viewController: UIViewController { get }

  /// Signal which says that the module has finished its work and can be closed.
  var finished: Observable<Void> { get }

  /// A demonstrator to show additional modules from this module.
  var demonstrator: Demonstrator? { get set }
}


public extension Module {

  /// Signal which says that the module has finished its work and can be closed.
  var finishedAsSingle: Single<Void> { finished.take(1).asSingle() }
}
