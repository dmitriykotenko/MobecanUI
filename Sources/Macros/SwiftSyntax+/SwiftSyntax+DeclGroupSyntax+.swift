// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension DeclGroupSyntax {

  var asNamedDeclaration: NamedDeclSyntax? {
    asProtocol(NamedDeclSyntax.self)
  }

  var asExtensionDeclaration: ExtensionDeclSyntax? {
    self.as(ExtensionDeclSyntax.self)
  }

  var asNominalType: NominalType? {
    asStruct?.asNominalType
    ?? asEnum?.asNominalType
  }

  var isStruct: Bool {
    self.is(StructDeclSyntax.self)
  }

  var asStruct: Struct? {
    zip(self.as(StructDeclSyntax.self), storedProperties)
      .map {
        Struct(
          name: $0.name.text,
          genericArguments: $0.genericParameterClause?.parameters.map(\.name.text) ?? [],
          storedProperties: $1
        )
      }
  }

  var structName: String? {
    self.as(StructDeclSyntax.self)?.name.text
  }

  var isEnum: Bool {
    self.is(EnumDeclSyntax.self)
  }

  var asEnum: Enum? {
    self.as(EnumDeclSyntax.self).map {
      Enum(
        name: $0.name.text,
        genericArguments: $0.genericParameterClause?.parameters.map(\.name.text) ?? [],
        cases: $0.simplifiedCases
      )
    }
  }

  var enumName: String? {
    self.as(EnumDeclSyntax.self)?.name.text
  }

  var visibilityModifiers: [String] {
    modifiers.filter(\.isVisibilityModifier).map(\.name.text)
  }

  var genericArguments: [String]? {
    asStruct?.genericArguments ?? asEnum?.genericArguments
  }

  var inheritedTypes: [String]? {
    inheritanceClause?.inheritedTypes.compactMap {
      $0.type.as(IdentifierTypeSyntax.self)?.name.text
    }
  }

  var storedProperties: [StoredProperty] {
    let members = memberBlock.members
    let variables = members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
    return variables.compactMap(\.asStoredProperty)
  }

  var initializers: [InitializerDeclSyntax] {
    let members = memberBlock.members
    return members.compactMap { $0.decl.as(InitializerDeclSyntax.self) }
  }

  var explicitCodingKeys: [EnumCase]? {
    findNestedEnum(name: "CodingKeys")?.simplifiedCases
  }

  func findNestedEnum(name: String) -> EnumDeclSyntax? {
    memberBlock.members.lazy
      .compactMap { $0.decl.as(EnumDeclSyntax.self) }
      .filter { $0.name.text == name }
      .first
  }

  var isRawValueRepresentableEnum: Bool {
    primitiveTypes.intersection(inheritedTypes ?? []).isNotEmpty
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

