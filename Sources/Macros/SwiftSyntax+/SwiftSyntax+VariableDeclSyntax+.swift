// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension VariableDeclSyntax {

  var isSingleVariable: Bool { bindings.count == 1 }

  var isStoredProperty: Bool {
    isSingleVariable && bindings.first?.accessorBlock == nil
  }

  var asStoredProperty: StoredProperty? {
    guard isStoredProperty else { return nil }

    return bindings.first.flatMap {
      StoredProperty(
        name: $0.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
        type: $0.typeAnnotation?.type.trimmedDescription
      )
    }
  }
}
