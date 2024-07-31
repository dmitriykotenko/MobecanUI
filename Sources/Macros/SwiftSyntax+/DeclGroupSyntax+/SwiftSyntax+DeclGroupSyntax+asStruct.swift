// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension DeclGroupSyntax {

  var isStruct: Bool {
    self.is(StructDeclSyntax.self)
  }

  var asStruct: Struct? {
    self.as(StructDeclSyntax.self).map {
      Struct(
        visibilityModifiers: visibilityModifiers,
        name: $0.name.text,
        genericArguments: $0.genericParameterClause?.parameters.map(\.name.text) ?? [],
        storedProperties: storedProperties
      )
    }
  }
}
