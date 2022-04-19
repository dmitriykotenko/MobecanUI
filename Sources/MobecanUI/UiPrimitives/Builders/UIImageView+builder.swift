// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIImageView {
  
  @discardableResult
  func contentMode(_ contentMode: UIImageView.ContentMode) -> Self {
    self.contentMode = contentMode
    return self
  }
  
  @discardableResult
  func image(_ image: UIImage) -> Self {
    self.image = image
    return self
  }

  @discardableResult
  func mobecanImage(_ image: Image?,
                    hideIfNil: Bool = false) -> Self {
    setMobecanImage(
      image,
      hideIfNil: hideIfNil
    )
    return self
  }
}
