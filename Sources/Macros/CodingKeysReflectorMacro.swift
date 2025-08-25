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
                               conformingTo protocols: [TypeSyntax],
                               in context: some MacroExpansionContext) throws -> [DeclSyntax] {

    generateCodingKeyTypes(declaration: declaration).asSequence
  }

  private static func generateCodingKeyTypes(declaration: some DeclGroupSyntax) -> DeclSyntax? {
    guard !declaration.isRawValueRepresentableEnum else { return nil }

    let members = declaration.memberBlock.members
    let variables = members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
    let variables2 = variables.filter(\.isStoredProperty)
//    let storedProperties = variables.compactMap(\.asStoredProperty)

    let codingKeysEnum = declaration.findNestedEnum(name: "CodingKeys")
    let codingCases = codingKeysEnum?.simplifiedCases.asSet ?? []

    func getCodingKey(_ variable: VariableDeclSyntax) -> String {
      codingKey(variable: variable, codingKeys: codingCases)
    }

//    let correctedStoredProperties =
//      storedProperties.map { $0.replacingName(usingCodingKeys: codingCases) }
//
//    let codingKeyTypes =
//      dictionaryLiteral(keysAndValues: correctedStoredProperties.map {($0.name, $0.type + ".self") })

//    return """
//      static var codingKeyTypes: [String: CodingKeysReflector.Type] {
//      \(raw: "  ".prependingToLines(of: codingKeyTypes))
//      }
//      """

//    static var codingKeyTypes: [String: CodingKeysReflector.Type] {
//      [
//        "id": String?.self,
//        "title": String.self,
//        "modified_at": Int64.self
//      ]
//    }

    return _computedVar(
      modifiers: [m.static],
      "codingKeyTypes",
      _t(_dictionary: _t("String"), _t("CodingKeysReflector")._t("Type"))
    ) {
      if variables2.isEmpty {
        _emptyDictionaryLiteral
      } else {
        _dictionaryLiteral {
          for variable in variables2 {
            _string(getCodingKey(variable)) <- _e(variable.aType!).dot("self")
          }
        }
//        q.e.dictionaryLiteral(.init(variables2.enumerated().map { index, variable in
//          DictionaryElementSyntax(
//            leadingTrivia: .newline,
//            key: _string(
//              codingKey(variable: variable, codingKeys: codingCases)
//            ),
//            colon: .colonToken(trailingTrivia: .space),
//            value: _e(variable.aType!).dot("self"),
//            trailingComma: variables2.trailingComma(forIndex: index),
//            trailingTrivia: index == variables2.count - 1 ? .newline : nil
//          )
//        }))
      }
    }
  }

  static func codingKey(variable: VariableDeclSyntax,
                        codingKeys: Set<EnumCase>) -> String {
    let rawValue = codingKeys.first { $0.name == variable.aName?.text }?.rawValue?
      .trimmingCharacters(in: .init(charactersIn: "\""))
      .trimmingCharacters(in: .whitespacesAndNewlines)

    return rawValue ?? variable.aName!.text
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


extension VariableDeclSyntax {

  var aName: TokenSyntax? {
    bindings.first?
      .pattern.as(IdentifierPatternSyntax.self)?
      .identifier
  }

  var aType: TypeSyntax? {
    bindings.first?.typeAnnotation?.type
  }
}
