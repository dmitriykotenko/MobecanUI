//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import RxOptional


public extension ObservableType {
  
  var previous: Observable<Element> {
    withPrevious().map { previous, _ in previous }
  }
  
  func withPrevious(startWith first: Element) -> Observable<(Element, Element)> {
    scan((first, first)) { ($0.1, $1) }
  }

  func withPrevious() -> Observable<(Element, Element)> {
    let arrays = scan([]) {
      Array(($0 + [$1]).suffix(2))
    }
    
    return arrays.skip(1).map { ($0[0], $0[1]) }
  }
}
