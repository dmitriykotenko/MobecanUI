// Copyright © 2024 Mobecan. All rights reserved.


extension Sequence {

  func filterNil<WrappedElement>() -> [WrappedElement] where Element == WrappedElement? {
    compactMap { $0 }
  }
}
