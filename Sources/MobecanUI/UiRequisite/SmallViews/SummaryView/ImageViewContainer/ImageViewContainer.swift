// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


open class ImageViewContainer {

  let imageView: UIImageView
  let containerView: UIView

  open func alignImage(inside superview: UIView) {}
  open func display(image: Image?) {}
  
  init(imageView: UIImageView,
       containerView: UIView) {
    self.imageView = imageView
    self.containerView = containerView
  }
}
