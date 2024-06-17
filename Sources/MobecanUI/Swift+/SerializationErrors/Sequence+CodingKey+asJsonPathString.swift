// Copyright © 2024 Mobecan. All rights reserved.



public extension Sequence where Element: CodingKey {

  var asJsonPathString: String {
    map(\.asCodableValue).asJsonPathString
  }
}
