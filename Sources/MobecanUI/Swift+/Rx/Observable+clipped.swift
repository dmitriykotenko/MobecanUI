//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


public extension Observable where Element: Comparable {
  
  func clipped(inside bounds: ClosedRange<Element>) -> Observable<Element> {
    return map { $0.clipped(inside: bounds) }
  }
  
  func clippedWith(bounds: Observable<ClosedRange<Element>>) -> Observable<Element> {
    return
      withLatestFrom(bounds) { $0.clipped(inside: $1) }
  }
}
