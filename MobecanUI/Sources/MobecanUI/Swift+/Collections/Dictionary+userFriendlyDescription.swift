//  Copyright © 2020 Mobecan. All rights reserved.


public extension Dictionary {
  
  var userFriendlyDescription: String {
    map { key, value in "\(key): \(value)" }
      .mkStringWithNewLine()
  }
}
