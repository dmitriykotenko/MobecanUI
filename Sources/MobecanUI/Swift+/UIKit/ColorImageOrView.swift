//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public enum ColorImageOrView: Equatable, Hashable {
  
  case color(UIColor)
  case image(UIImage)
  case view(UIView)
}
