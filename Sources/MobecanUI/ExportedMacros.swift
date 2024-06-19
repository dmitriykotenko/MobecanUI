// Copyright © 2024 Mobecan. All rights reserved.


@attached(extension, conformances: EmptyCodingKeysReflector, SimpleCodingKeysReflector)
@attached(member, names: named(codingKeyTypes))
@available(swift 5.9)
public macro CodingKeysReflection() = #externalMacro(
  module: "MobecanUIMacros", 
  type: "CodingKeysReflectionMacro"
)
