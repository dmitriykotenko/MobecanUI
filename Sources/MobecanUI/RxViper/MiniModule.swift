// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public protocol MiniModule: AnyObject {
  
  var uiView: UIView { get }
  var demonstrator: Demonstrator? { get set }
}
