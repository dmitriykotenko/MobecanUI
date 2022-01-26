// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public protocol EventfulView: UIView {
  
  associatedtype ViewEvent
  
  var viewEvents: Observable<ViewEvent> { get }
}
