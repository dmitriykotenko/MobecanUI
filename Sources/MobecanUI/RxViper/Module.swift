//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public protocol Module {
  
  var viewController: UIViewController { get }
  var finished: Observable<Void> { get }
}
