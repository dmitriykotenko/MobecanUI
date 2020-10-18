//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension ObservableType where Element: Equatable {

  func whenIsEqual(to element: Element) -> Observable<Void> {
    filter { $0 == element }.mapToVoid()
  }

  func whenNotEqual(to element: Element) -> Observable<Void> {
    filter { $0 != element }.mapToVoid()
  }
}
