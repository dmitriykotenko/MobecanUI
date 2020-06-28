//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public protocol ImageViewContainer {

  var containerView: UIView { get }

  func alignImage(inside superview: UIView)
  func display(image: Image?)
}
