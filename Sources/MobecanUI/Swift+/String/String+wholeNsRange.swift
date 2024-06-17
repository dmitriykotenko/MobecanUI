// Copyright © 2024 Mobecan. All rights reserved.

import Foundation


public extension String {

  var wholeNsRange: NSRange { NSRange(startIndex..., in: self) }
}
