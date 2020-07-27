//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public protocol NavigationBarContentProvider {
  
  var navigationBarContent: Driver<NavigationBarContent> { get }
}
