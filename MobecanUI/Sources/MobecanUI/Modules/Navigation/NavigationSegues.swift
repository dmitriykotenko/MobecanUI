//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


public protocol NavigationSegues {
  
  func segues(module: Module) -> Observable<NavigationEvent>?
}
