import SwiftCompilerPlugin
import SwiftSyntaxMacros


/// Даёт Икскоду возможность использовать скомпилированные макросы.
@main
struct MobecanUIMacrosPlugin: CompilerPlugin {

  let providingMacros: [Macro.Type] = [
    CodingKeysReflectionMacro.self
  ]
}
