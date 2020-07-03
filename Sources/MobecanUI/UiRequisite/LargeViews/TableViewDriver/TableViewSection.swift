//  Copyright © 2020 Mobecan. All rights reserved.


public struct TableViewSection<Header, Element> {
  
  public let header: Header
  public let elements: [Element]
  
  public init(header: Header,
              elements: [Element]) {
    self.header = header
    self.elements = elements
  }
  
  public var withoutElements: TableViewSection<Header, Element> {
    TableViewSection(header: header, elements: [])
  }
  
  public func filterElements(_ predicate: (Element) -> Bool) -> Self {
    TableViewSection(
      header: header,
      elements: elements.filter(predicate)
    )
  }

  public func mapElements<OtherElement>(_ transform: (Element) -> OtherElement)
    -> TableViewSection<Header, OtherElement> {
      
      TableViewSection<Header, OtherElement>(
        header: header,
        elements: elements.map(transform)
      )
  }
  
  public func compactMapElements<OtherElement>(_ transform: (Element) -> OtherElement?)
    -> TableViewSection<Header, OtherElement> {
      
      TableViewSection<Header, OtherElement>(
        header: header,
        elements: elements.compactMap(transform)
      )
  }
}


extension TableViewSection: Equatable where Header: Equatable, Element: Equatable {
  
  public static func == (this: TableViewSection<Header, Element>,
                         that: TableViewSection<Header, Element>) -> Bool {
    this.header == that.header && this.elements == that.elements
  }
}


extension TableViewSection: Hashable where Header: Hashable, Element: Equatable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(header)
  }
}
