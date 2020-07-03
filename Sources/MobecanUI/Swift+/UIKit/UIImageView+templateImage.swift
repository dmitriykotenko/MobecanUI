//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIImageView {

  var templateImage: UIImage? {
    get {
      image?.withRenderingMode(.alwaysTemplate)
    }
    
    set {
      image = newValue?.withRenderingMode(.alwaysTemplate)
    }
  }
}
