//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public protocol OldNavigationPresenterProtocol {
  
  var backButtonTap: AnyObserver<Void> { get }

  var push: Signal<UIViewController> { get }
  var pop: Signal<Void> { get }
  var popTo: Signal<UIViewController> { get }
  var set: Signal<[UIViewController]> { get }
  var setInitial: Signal<UIViewController> { get }
  
  var dismiss: Signal<Void> { get }
}
