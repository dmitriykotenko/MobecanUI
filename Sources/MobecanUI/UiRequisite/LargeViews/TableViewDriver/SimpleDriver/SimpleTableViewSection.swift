// Copyright © 2020 Mobecan. All rights reserved.


public typealias SimpleTableViewSection<Element> = TableViewSection<SimpleTableViewHeader?, Element, EquatableVoid>


public extension TableViewSection where Header == SimpleTableViewHeader?, Footer == EquatableVoid {

  init(header: Header = nil,
       elements: [Element] = []) {
    self.init(
      header: header,
      elements: elements,
      footer: .instance
    )
  }
}
