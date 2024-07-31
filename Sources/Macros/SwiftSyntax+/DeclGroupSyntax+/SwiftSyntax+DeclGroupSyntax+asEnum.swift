// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension DeclGroupSyntax {

  var isEnum: Bool {
    self.is(EnumDeclSyntax.self)
  }

  var asEnum: Enum? {
    self.as(EnumDeclSyntax.self).map {
      Enum(
        visibilityModifiers: $0.visibilityModifiers,
        name: $0.name.text,
        genericArguments: $0.genericParameterClause?.parameters.map(\.name.text) ?? [],
        cases: $0.simplifiedCases
      )
    }
  }
}
