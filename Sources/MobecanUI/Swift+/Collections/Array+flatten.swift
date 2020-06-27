//  Copyright © 2020 Mobecan. All rights reserved.


public extension Array {

  func flatten<Value>() -> [Value] where Element == [Value] {
    return flatMap { $0 }
  }
}
