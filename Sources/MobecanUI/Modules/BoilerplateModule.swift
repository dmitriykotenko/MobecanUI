//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


open class BoilerplateModule: Module {
  
  open private(set) var finished = Observable<Void>.never()
  open private(set) var viewController: UIViewController

  open var demonstrator: Demonstrator?
  
  public convenience init(_ view: UIView) {
    self.init(view, demonstrator: nil)
  }
  
  public convenience init(_ view: UIView,
                          demonstrator: Demonstrator?) {
    self.init(
      BoilerplateViewController(view: view),
      demonstrator: demonstrator
    )
  }

  public convenience init(_ viewController: UIViewController) {
    self.init(viewController, demonstrator: nil)
  }

  public init(_ viewController: UIViewController,
              demonstrator: Demonstrator?) {
    self.viewController = viewController
    
    self.demonstrator =
      demonstrator ??
      UiKitDemonstrator(parentViewController: viewController)
  }
}
