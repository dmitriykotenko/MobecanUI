// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftSyntaxMacros


/// Даёт Икскоду возможность использовать указанные макросы во время компиляции.
@main
struct MobecanUIMacrosPlugin: CompilerPlugin {

  let providingMacros: [Macro.Type] = [
    UrlMacro.self,
    MemberwiseInitMacro.self,
    MemberwiseInitMacro2.self,
    TryInitMacro.self,
    TryInitMacro2.self,
    CodingKeysReflectorMacro.self,
    AutoGeneratableMacro.self,
  ]
}
