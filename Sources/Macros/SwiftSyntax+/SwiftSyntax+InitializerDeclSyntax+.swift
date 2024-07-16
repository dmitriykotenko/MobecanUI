// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension InitializerDeclSyntax {

  var visibilityModifiers: [String] {
    modifiers.filter(\.isVisibilityModifier).map(\.name.text)
  }
}

