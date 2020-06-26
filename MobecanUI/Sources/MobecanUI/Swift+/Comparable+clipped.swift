//  Copyright © 2020 Mobecan. All rights reserved.


public extension Comparable {
  
  @inlinable
  func clipped(inside bounds: ClosedRange<Self>) -> Self {
    let minimum = bounds.lowerBound
    let maximum = bounds.upperBound
    
    return  min(max(self, minimum), maximum)
  }
}
