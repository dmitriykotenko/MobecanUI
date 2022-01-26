// Copyright © 2020 Mobecan. All rights reserved.


public enum SimpleTableViewHeader {

  case loadingInProgress
  case nothingFound
  case error(String?)
  case string(String?)
}


public extension TableViewSection where Header == SimpleTableViewHeader? {
  
  static var loadingInProgress: TableViewSection<Header, Element> {
    TableViewSection(header: .loadingInProgress, elements: [])
  }
  
  static var nothingFound: TableViewSection<Header, Element> {
    TableViewSection(header: .nothingFound, elements: [])
  }

  static func error(_ errorText: String?) -> TableViewSection<Header, Element> {
    TableViewSection(header: .error(errorText), elements: [])
  }
}


public extension Array {
  
  func withTitle(_ title: String) -> TableViewSection<SimpleTableViewHeader?, Element> {
    TableViewSection(header: .string(title), elements: self)
  }
  
  func withoutTitle() -> TableViewSection<SimpleTableViewHeader?, Element> {
    TableViewSection(header: nil, elements: self)
  }
}
