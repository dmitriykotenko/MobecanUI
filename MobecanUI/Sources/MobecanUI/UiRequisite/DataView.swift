//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public protocol DataView: UIView {
  
  associatedtype Value
  
  var value: AnyObserver<Value?> { get }
}
