// Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func userFriendlyDescription<Key, Value>() -> String where Element == [Key: Value] {
    map { $0.userFriendlyDescription }
      .mkStringWithNewLine()
  }
}
