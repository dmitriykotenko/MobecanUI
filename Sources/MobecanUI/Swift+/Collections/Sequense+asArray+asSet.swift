// Copyright © 2023 Mobecan. All rights reserved.

import Foundation


public extension Sequence {

  var asArray: [Element] { Array(self) }
}


public extension Sequence where Element: Hashable {

  var asSet: Set<Element> { Set(self) }
}
