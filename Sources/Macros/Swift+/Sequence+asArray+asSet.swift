// Copyright © 2024 Mobecan. All rights reserved.


extension Sequence {

  var asArray: [Element] { Array(self) }
}


extension Sequence where Element: Hashable {

  var asSet: Set<Element> { .init(self) }
}
