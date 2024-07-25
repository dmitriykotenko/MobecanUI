// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public struct AutoGeneratableMacro {}


extension AutoGeneratableMacro: MemberMacro {

  public static func expansion(of node: AttributeSyntax,
                               providingMembersOf declaration: some DeclGroupSyntax,
                               in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    try (builtinGenerator(declaration: declaration, in: context)?.build).asSequence
  }

  private static func builtinGenerator(declaration: some DeclGroupSyntax,
                                       in context: some MacroExpansionContext) throws -> GeneratorDeclaration? {
    try ensureIsValid(declaration: declaration)

    return
      declaration
        .asStruct(inEnclosingContext: context)
        .flatMap { GeneratorDeclaration.from(someStruct: $0) }
      ?? declaration
        .asEnum(inEnclosingContext: context)
        .flatMap { GeneratorDeclaration.from(someEnum: $0) }
  }
}


extension AutoGeneratableMacro: ExtensionMacro {

  public static func expansion(of node: AttributeSyntax,
                               attachedTo declaration: some DeclGroupSyntax,
                               providingExtensionsOf type: some TypeSyntaxProtocol,
                               conformingTo protocols: [TypeSyntax],
                               in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
    // Чтобы не плодить сообщения об ошибке, выводим их только при генерации мемберов.
    do { try ensureIsValid(declaration: declaration) }
    catch { return [] }

    guard var nominalType = declaration.asNominalType(inEnclosingContext: context)
    else { return [] }
    
    // В экстеншене надо указывать полное имя структуры или енума.
    nominalType.name = type.trimmedDescription

    return [
      recursiveConformance(
        of: nominalType,
        to: "AutoGeneratable",
        body: declarationOfDefaultGenerator(
          for: declaration, 
          in: context,
          qualifiedTypeName: nominalType.name
        )
      )
    ]
  }

  private static func declarationOfDefaultGenerator(for declaration: some DeclGroupSyntax,
                                                    in context: some MacroExpansionContext,
                                                    qualifiedTypeName: String) -> String {
    let visibilityModifiers = declaration.visibilityModifiers(forEnclosingContext: context)
    let isPublic = visibilityModifiers.contains { $0 == "public" || $0 == "open" }
    let visibility = isPublic ? "public" : nil

    let keywords = [visibility, "static", "var"].filterNil().mkStringWithSpace()

    switch declaration.asEnum {
    case let someEnum? where someEnum.isPrimitive:
      return """
      \(keywords) defaultGenerator: MobecanGenerator<\(qualifiedTypeName)> {
        .oneOf(\(someEnum.cases.map(\.dotName).mkStringWithComma()))
      }
      """
    default:
      return """
      \(keywords) defaultGenerator: BuiltinGenerator {
        .init()
      }
      """
    }
  }
}
