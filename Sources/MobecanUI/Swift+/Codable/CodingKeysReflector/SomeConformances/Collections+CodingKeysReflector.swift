// Copyright © 2024 Mobecan. All rights reserved.

import Foundation


extension Array: CodingKeysReflector where Element: CodingKeysReflector {

  public static func typeOfValue(
    atCodingKey key: CodingKey
  ) -> Result<CodingKeysReflector.Type, CodingKeysReflectorError> {

    key.intValue != nil ?
      .success(Element.self) : 
      .failure(.invalidCodingKey(key))
  }
}


extension Dictionary: CodingKeysReflector where Key == String, Value: CodingKeysReflector {

  public static func typeOfValue(
    atCodingKey key: CodingKey
  ) -> Result<CodingKeysReflector.Type, CodingKeysReflectorError> {

    key.intValue == nil ?
      .success(Value.self) :
      .failure(.invalidCodingKey(key))
  }
}
