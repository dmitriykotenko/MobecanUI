// Copyright © 2024 Mobecan. All rights reserved.


extension Optional: CodingKeysReflector where Wrapped: CodingKeysReflector {

  public static func typeOfValue(
    atCodingKey key: CodingKey
  ) -> Result<CodingKeysReflector.Type, CodingKeysReflectorError> {
    
    Wrapped.typeOfValue(atCodingKey: key)
  }
}
