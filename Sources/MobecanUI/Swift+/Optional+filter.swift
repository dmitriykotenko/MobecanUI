//  Copyright © 2020 Mobecan. All rights reserved.


public extension Optional {
  
  func filter(_ predicate: @escaping (Wrapped) -> Bool) -> Wrapped? {
    flatMap { predicate($0) ? $0 : nil }
  }
}
