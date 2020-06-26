//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public class BoilerplateModule: Module {
  
  public let finished = Observable<Void>.never()  
  public let viewController: UIViewController
  
  public init(_ viewController: UIViewController) {
    self.viewController = viewController
  }
}
