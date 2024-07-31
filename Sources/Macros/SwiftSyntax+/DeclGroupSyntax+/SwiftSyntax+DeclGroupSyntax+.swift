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
    asClass?.asNominalType
    ?? asStruct?.asNominalType
    ?? asEnum?.asNominalType
  }

  var simplifiedAttributes: [String] {
    attributes
      .compactMap { $0.as(AttributeSyntax.self) }
      .map(\.attributeName.trimmedDescription)
  }

  func contains(attribute: String) -> Bool {
    simplifiedAttributes.contains(attribute)
  }

  var visibilityModifiers: [VisibilityModifier] {
    modifiers
      .filter(\.isVisibilityModifier)
      .compactMap { .init(rawValue: $0.name.text) }
  }

  var visibilityPrefix: String {
    visibilityModifiers.isEmpty ? "" : visibilityModifiers.mkStringWithComma() + " "
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

  // MARK: Initializers
  var initializers: [Function] {
    explicitInitializers + implicitInitializer.asSequence
  }

  var initializersIncludingMacroGenerated: [Function] {
    explicitInitializers
    + implicitInitializer.asSequence
    + macroGeneratedMemberwiseInitializer.asSequence
  }


  var explicitInitializers: [Function] {
    memberBlock.members
      .compactMap { $0.decl.as(InitializerDeclSyntax.self) }
      .map(\.asFunction)
  }

  var implicitInitializer: Function? {
    (asStruct?.inferredMemberwiseInitializer)
      .filter { _ in explicitInitializers.isEmpty }
      .filter { _ in macroGeneratedMemberwiseInitializer == nil }
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

