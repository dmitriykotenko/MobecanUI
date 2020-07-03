//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public protocol PlaceholderContainer: UIView {
  
  var placeholder: String? { get set }
}


extension UITextField: PlaceholderContainer {}


public extension PlaceholderContainer {
  
  var rxPlaceholder: Binder<String?> {
    Binder(
      self,
      binding: { view, placeholder in view.placeholder = placeholder }
    )
  }
}
