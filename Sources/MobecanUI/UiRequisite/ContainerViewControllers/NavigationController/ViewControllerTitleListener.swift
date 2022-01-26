// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public class ViewControllerTitleListener {
  
  @RxDriverOutput(nil) public var title: Driver<String?>
  
  private var titleListener: NSObjectProtocol?
  
  public init(viewController: UIViewController?) {
    _title.onNext(viewController?.title)
    
    titleListener = viewController?.titleListener { [weak self] _, change in
      if let newTitle = change.newValue {
        self?._title.onNext(newTitle)
      }
    }
  }
}


private extension UIViewController {
  
  func titleListener(changeHandler: @escaping (UIViewController, NSKeyValueObservedChange<String?>) -> Void)
    -> NSKeyValueObservation {
      
      observe(\.title, options: [.new], changeHandler: changeHandler)
  }
}
