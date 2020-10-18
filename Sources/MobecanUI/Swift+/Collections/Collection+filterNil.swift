//  Copyright © 2020 Mobecan. All rights reserved.


public extension Collection {

  func filterNil<NestedElement>() -> [NestedElement] where Element == NestedElement? {
    compactMap { $0 }
  }

  func filterNilKeepOptional<NestedElement>() -> [Element] where Element == NestedElement? {
    filter { $0 != nil }
  }
}
