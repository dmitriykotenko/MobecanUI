// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension DeclGroupSyntax {

  var isClass: Bool {
    self.is(ClassDeclSyntax.self)
  }

  var asClass: Class? {
    self.as(ClassDeclSyntax.self).map {
      Class(
        visibilityModifiers: visibilityModifiers,
        name: $0.name.text,
        genericArguments: $0.genericParameterClause?.parameters.map(\.name.text) ?? [],
        storedProperties: storedProperties
      )
    }
  }
}
