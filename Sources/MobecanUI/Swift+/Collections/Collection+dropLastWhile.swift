// Copyright © 2021 Mobecan. All rights reserved.

import Foundation


public extension Collection {

  func dropLastWhile(_ condition: (Element) -> Bool) -> [Element] {
    reversed().drop(while: condition).reversed()
  }
}
