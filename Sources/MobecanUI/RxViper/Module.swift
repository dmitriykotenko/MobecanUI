//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public protocol Module {
  
  var viewController: UIViewController { get }
  var finished: Observable<Void> { get }

  var demonstrator: Demonstrator? { get set }
}


public extension Module {

  var finishedAsSingle: Single<Void> { finished.take(1).asSingle() }
}
