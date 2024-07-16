// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


/// Генерирует реализацию протокола `CodingKeysReflector`
/// для енумов без ассоциированных значений, классов и структур.
public struct CodingKeysReflectorMacro {}


extension CodingKeysReflectorMacro: MemberMacro {

  public static func expansion(of node: AttributeSyntax,
                               providingMembersOf declaration: some DeclGroupSyntax,
                               in context: some MacroExpansionContext) throws -> [DeclSyntax] {

    generateCodingKeyTypes(declaration: declaration).asArray
  }

  private static func generateCodingKeyTypes(declaration: some DeclGroupSyntax) -> DeclSyntax? {
    guard !declaration.isRawValueRepresentableEnum else { return nil }

    let members = declaration.memberBlock.members
    let variables = members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
    let storedProperties = variables.compactMap(\.asStoredProperty)

    let codingKeysEnum = declaration.findNestedEnum(name: "CodingKeys")
    let codingCases = codingKeysEnum?.simplifiedCases.asSet ?? []

    let correctedStoredProperties =
      storedProperties.map { $0.replacingName(usingCodingKeys: codingCases) }

    let codingKeyTypes =
      dictionaryLiteral(keysAndValues: correctedStoredProperties.map {($0.name, $0.type + ".self") })

    return """
      static var codingKeyTypes: [String: CodingKeysReflector.Type] {
      \(raw: "  ".prependingToLines(of: codingKeyTypes))
      }
      """
  }
}


extension CodingKeysReflectorMacro: ExtensionMacro {

  public static func expansion(of node: AttributeSyntax,
                               attachedTo declaration: some DeclGroupSyntax,
                               providingExtensionsOf type: some TypeSyntaxProtocol,
                               conformingTo protocols: [TypeSyntax],
                               in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
    [
      conformance(
        of: type,
        to: declaration.isRawValueRepresentableEnum ? "EmptyCodingKeysReflector" : "SimpleCodingKeysReflector"
      )
    ]
  }
}
