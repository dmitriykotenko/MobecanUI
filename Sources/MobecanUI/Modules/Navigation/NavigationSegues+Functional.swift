//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


open class FunctionalNavigationSegues<SomeModule: Module>: NavigationSegues {
  
  private let listener: (SomeModule) -> Observable<NavigationEvent>

  public init(listener: @escaping (SomeModule) -> Observable<NavigationEvent>) {
    self.listener = listener
  }
  
  public func segues(module: Module) -> Observable<NavigationEvent>? {
    (module as? SomeModule).map { listener($0) }
  }
}
