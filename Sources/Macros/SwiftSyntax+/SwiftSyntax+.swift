// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension DeclGroupSyntax {

  func findNestedEnum(name: String) -> EnumDeclSyntax? {
    memberBlock.members.lazy
      .compactMap { $0.decl.as(EnumDeclSyntax.self) }
      .filter { $0.name.text == name }
      .first
  }

  var isRawValueRepresentableEnum: Bool {
    primitiveTypes.intersection(inheritedTypes ?? []).isNotEmpty
  }

  var inheritedTypes: [String]? {
    inheritanceClause?.inheritedTypes.compactMap {
      $0.type.as(IdentifierTypeSyntax.self)?.name.text
    }
  }

  var asNamedDeclaration: NamedDeclSyntax? { asProtocol(NamedDeclSyntax.self) }

  var asExtensionDeclaration: ExtensionDeclSyntax? { self.as(ExtensionDeclSyntax.self) }

  var typeName: String? {
    let parentTypeName = "\(String(describing: parent)) --> "

    return parentTypeName + (
      asNamedDeclaration?.name.text
      ?? asExtensionDeclaration?.extendedType.trimmedDescription
      ?? "[]"
    )
  }
}


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


extension EnumDeclSyntax {

  var cases: [EnumCaseDeclSyntax] {
    memberBlock.members.compactMap {
      $0.decl.as(EnumCaseDeclSyntax.self)
    }
  }

  var simplifiedCases: [EnumCase] {
    cases
      .compactMap(\.elements.first)
      .compactMap {
        EnumCase(
          name: $0.name.text,
          rawValue: $0.rawValue?.value.trimmedDescription,
          parameters:
            $0.parameterClause?.parameters
              .map {
                .init(
                  name: $0.firstName?.text,
                  type: $0.type.trimmedDescription
                )
              }
              ?? []
        )
      }
  }
}


private let primitiveTypes: Set = [
  "Bool",
  "Int",
  "UInt",
  "Int8",
  "UInt8",
  "Int16",
  "UInt16",
  "Int32",
  "UInt32",
  "Int64",
  "UInt64",
  "Int128",
  "UInt128",
  "Float",
  "Float16",
  "Double",
  "Decimal",
  "NSNumber",
  "String"
]

