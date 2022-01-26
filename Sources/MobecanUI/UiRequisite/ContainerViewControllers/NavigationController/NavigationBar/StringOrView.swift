// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public enum StringOrView: Equatable, Hashable {
  
  case string(String)
  case attributedString(NSAttributedString)
  case view(UIView)
}
