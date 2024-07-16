// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension DeclModifierSyntax {

  var isVisibilityModifier: Bool {
    ["private", "fileprivate", "internal", "public", "open"].contains(name.text)
  }
}
