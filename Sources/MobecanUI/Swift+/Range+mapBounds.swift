// Copyright © 2024 Mobecan. All rights reserved.


public extension Range {

  func mapBounds<OtherBound>(_ transform: (Bound) -> OtherBound) -> Range<OtherBound> {
    transform(lowerBound)..<transform(upperBound)
  }
}


public extension ClosedRange {

  func mapBounds<OtherBound>(_ transform: (Bound) -> OtherBound) -> ClosedRange<OtherBound> {
    transform(lowerBound)...transform(upperBound)
  }
}
