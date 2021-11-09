// Copyright © 2021 Mobecan. All rights reserved.

import RxSwift
import UIKit


public protocol HasEmptyElement {

  static func emptyElement() -> Self
}


extension String: HasEmptyElement {

  public static func emptyElement() -> String { "" }
}


extension Optional: HasEmptyElement {

  public static func emptyElement() -> Wrapped? { nil }
}


extension Array: HasEmptyElement {

  public static func emptyElement() -> [Element] { [] }
}
