// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIImage {

  func tintedWith(_ color: UIColor) -> Image {
    .tintedImage(self, color)
  }
}
