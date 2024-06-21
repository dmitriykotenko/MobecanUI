// Copyright © 2024 Mobecan. All rights reserved.

import Foundation


@attached(extension, conformances: EmptyCodingKeysReflector, SimpleCodingKeysReflector)
@attached(member, names: named(codingKeyTypes))
@available(swift 5.9)
public macro CodingKeysReflection() = #externalMacro(
  module: "MobecanUIMacros", 
  type: "CodingKeysReflectionMacro"
)


@freestanding(expression)
@available(swift 5.9)
public macro URL(_ string: String) -> URL = #externalMacro(
  module: "MobecanUIMacros",
  type: "UrlMacro"
)
