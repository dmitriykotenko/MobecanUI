// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension VariableDeclSyntax {

  var isSingleVariable: Bool { bindings.count == 1 }

  var isStatic: Bool {
    modifiers.contains { $0.name.text == "static" }
  }

  var isStoredProperty: Bool {
    isSingleVariable && !isStatic && bindings.first?.accessorBlock == nil
  }

  var asStoredProperty: StoredProperty? {
    guard isStoredProperty else { return nil }

    return bindings.first.flatMap {
      StoredProperty(
        kind: bindingSpecifier.text,
        name: $0.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
        type: $0.typeAnnotation?.type.trimmedDescription,
        defaultValue: $0.initializer?.value.trimmedDescription
      )
    }
  }

  var asStoredProperty2: StoredProperty2? {
    guard isStoredProperty else { return nil }

    return bindings.first.flatMap {
      StoredProperty2(
        kind: bindingSpecifier.text,
        name: $0.pattern.as(IdentifierPatternSyntax.self)?.identifier,
        typeDecl: $0.typeAnnotation?.type,
        defaultValueDecl: $0.initializer
      )
    }
  }
}
