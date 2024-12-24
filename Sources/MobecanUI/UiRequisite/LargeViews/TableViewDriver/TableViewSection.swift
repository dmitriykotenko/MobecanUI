// Copyright © 2020 Mobecan. All rights reserved.


@MemberwiseInit
public struct TableViewSection<Header, Element, Footer>: Lensable {

  public var header: Header
  public var elements: [Element]
  public var footer: Footer

  public var withoutElements: TableViewSection<Header, Element, Footer> {
    .init(
      header: header,
      elements: [],
      footer: footer
    )
  }
  
  public func filterElements(_ predicate: (Element) -> Bool) -> Self {
    .init(
      header: header,
      elements: elements.filter(predicate),
      footer: footer
    )
  }

  public func mapElements<OtherElement>(_ transform: (Element) -> OtherElement)
  -> TableViewSection<Header, OtherElement, Footer> {
    .init(
      header: header,
      elements: elements.map(transform),
      footer: footer
    )
  }
  
  public func compactMapElements<OtherElement>(_ transform: (Element) -> OtherElement?)
  -> TableViewSection<Header, OtherElement, Footer> {
    .init(
      header: header,
      elements: elements.compactMap(transform),
      footer: footer
    )
  }
}


extension TableViewSection: Equatable where Header: Equatable, Element: Equatable, Footer: Equatable {

  public static func == (this: TableViewSection<Header, Element, Footer>,
                         that: TableViewSection<Header, Element, Footer>) -> Bool {
    this.header == that.header
    && this.elements == that.elements
    && this.footer == that.footer
  }
}


extension TableViewSection: Hashable where Header: Hashable, Element: Equatable, Footer: Hashable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(header)
    hasher.combine(footer)
  }
}
