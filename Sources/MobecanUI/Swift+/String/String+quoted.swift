// Copyright © 2024 Mobecan. All rights reserved.

import Foundation


public extension String {

  var quoted: String {
    """
    "\(self)"
    """
  }
}
