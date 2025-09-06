// Copyright © 2020 Mobecan. All rights reserved.


public enum SimpleTableViewHeader {

  case loadingInProgress
  case nothingFound
  case error(String?)
  case string(String?)
}


public extension TableViewSection where Header == SimpleTableViewHeader?, Footer == EVoid {

  static var loadingInProgress: TableViewSection<Header, Element, Footer> {
    .init(
      header: .loadingInProgress,
      elements: [],
      footer: .instance
    )
  }
  
  static var nothingFound: TableViewSection<Header, Element, Footer> {
    .init(
      header: .nothingFound,
      elements: [],
      footer: .instance
    )
  }

  static func error(_ errorText: String?) -> TableViewSection<Header, Element, Footer> {
    .init(
      header: .error(errorText),
      elements: [],
      footer: .instance
    )
  }

  static func string(_ string: String?) -> TableViewSection<Header, Element, Footer> {
    .init(
      header: .string(string),
      elements: [],
      footer: .instance
    )
  }
}


public extension Array {
  
  func withTitle(_ title: String) -> TableViewSection<SimpleTableViewHeader?, Element, EVoid> {
    .init(
      header: .string(title),
      elements: self,
      footer: .instance
    )
  }
  
  func withoutTitle() -> TableViewSection<SimpleTableViewHeader?, Element, EVoid> {
    .init(
      header: nil, 
      elements: self,
      footer: .instance
    )
  }
}
