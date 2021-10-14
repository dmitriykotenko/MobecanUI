//  Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


infix operator =^ : DefaultPrecedence


public extension ObserverType {

  static func =^ (observer: Self, value: Element) {
    observer.onNext(value)
  }

  static func =^ <NestedElement>(observer: Self, value: NestedElement) where Element == NestedElement? {
    observer.onNext(value)
  }
}
