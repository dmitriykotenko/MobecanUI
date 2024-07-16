// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public extension Macro {

  static var mangledTypeNameOfMacro: String {
    if #available(iOS 14.0, *) {
      "Mangled name of macro \(Self.self): " + _mangledTypeName(Self.self)!
    } else {
      "No mangled name for macro \(Self.self)"
    }
  }
}
