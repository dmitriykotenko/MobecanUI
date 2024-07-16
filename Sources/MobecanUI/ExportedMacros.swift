// Copyright © 2024 Mobecan. All rights reserved.

import Foundation


@attached(extension, conformances: EmptyCodingKeysReflector, SimpleCodingKeysReflector)
@attached(member, names: named(codingKeyTypes))
@available(swift 5.9)
public macro DerivesCodingKeysReflector() = #externalMacro(
  module: "MobecanUIMacros", 
  type: "CodingKeysReflectorMacro"
)


@attached(extension, conformances: AutoGeneratable, names: arbitrary)
@attached(member, names: arbitrary)
@available(swift 5.9)
public macro DerivesAutoGeneratable() = #externalMacro(
  module: "MobecanUIMacros",
  type: "AutoGeneratableMacro"
)


@freestanding(expression)
@available(swift 5.9)
public macro URL(_ string: String) -> URL = #externalMacro(
  module: "MobecanUIMacros",
  type: "UrlMacro"
)
