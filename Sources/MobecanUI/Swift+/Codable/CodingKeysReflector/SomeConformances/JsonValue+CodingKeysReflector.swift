// Copyright © 2024 Mobecan. All rights reserved.


extension JsonValue: CodingKeysReflector {

  public static func typeOfValue(
    atCodingKey: CodingKey
  ) -> Result<CodingKeysReflector.Type, CodingKeysReflectorError> {
    .success(JsonValue.self)
  }
}
