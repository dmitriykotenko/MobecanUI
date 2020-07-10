//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public class BoilerplateModule: Module {
  
  public let finished = Observable<Void>.never()  
  public let viewController: UIViewController

  public var demonstrator: Demonstrator?
  
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
