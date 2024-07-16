// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension AutoGeneratableMacro {

  static func ensureIsValid(declaration: some DeclGroupSyntax) throws {
    try ensureIsStructOrEnum(declaration: declaration)
    try reportIfStructContainsTuples(declaration: declaration)
    try reportIfEnumContainsTuples(declaration: declaration)
    try reportIfEnumContainsDuplicatedCaseNames(declaration: declaration)
  }

  static func ensureIsStructOrEnum(declaration: some DeclGroupSyntax) throws {
    if !declaration.isStruct && !declaration.isEnum {
      throw DiagnosticsError(diagnostics: [
        .init(
          node: Syntax(fromProtocol: declaration),
          message: MobecanDiagnosticMessage(
            message: "Макрос @DerivesAutoGeneratable поддерживает только структуры и енумы.",
            diagnosticID: .init(domain: "generator-macro", id: "non-struct-non-enum"),
            severity: .error
          )
        )
      ])
    }
  }

  static func reportIfStructContainsTuples(declaration: some DeclGroupSyntax) throws {
    guard let structDeclaration = declaration.as(StructDeclSyntax.self)
    else { return }

    let members = structDeclaration.memberBlock.members

    let storedProperties = members
      .compactMap { $0.decl.as(VariableDeclSyntax.self) }
      .filter(\.isStoredProperty)

    let explicitTuples = storedProperties
      .flatMap(\.bindings)
      .compactMap(\.typeAnnotation?.type)
      .flatMap(\.withAllNestedTypes)
      .compactMap { $0.as(TupleTypeSyntax.self) }

    let implicitTuples = storedProperties
      .flatMap(\.bindings)
      .compactMap(\.initializer?.value)
      .compactMap { $0.as(TupleExprSyntax.self) }

    let tuples: [any SyntaxProtocol] = explicitTuples + implicitTuples

    if tuples.isNotEmpty {
      throw DiagnosticsError(diagnostics: tuples.map {
        .init(
          node: Syntax(fromProtocol: $0),
          message: MobecanDiagnosticMessage.tuplesAmongStoredProperties
        )
      })
    }
  }

  static func reportIfEnumContainsTuples(declaration: some DeclGroupSyntax) throws {
    guard let enumDeclaration = declaration.as(EnumDeclSyntax.self) else { return }

    let cases = enumDeclaration.cases.flatMap(\.elements)

    let tuples = cases
      .compactMap(\.parameterClause)
      .flatMap(\.parameters)
      .map(\.type)
      .compactMap { $0.as(TupleTypeSyntax.self) }

    if tuples.isNotEmpty {
      throw DiagnosticsError(diagnostics: tuples.map {
        .init(
          node: Syntax(fromProtocol: $0),
          message: MobecanDiagnosticMessage.tuplesAmongStoredProperties
        )
      })
    }
  }

  static func reportIfEnumContainsDuplicatedCaseNames(declaration: some DeclGroupSyntax) throws {
    guard let enumDeclaration = declaration.as(EnumDeclSyntax.self) else { return }

    let cases = enumDeclaration.cases.flatMap(\.elements)

    guard cases.isNotEmpty else {
      throw DiagnosticsError(diagnostics: [
        .init(
          node: Syntax(fromProtocol: declaration),
          message: MobecanDiagnosticMessage(
            message: "У енума нет ни одного кейса, поэтому его невозможно сгенерировать.",
            diagnosticID: .init(domain: "generator-macro", id: "empty-enum"),
            severity: .error
          )
        )
      ])
    }

    let duplicates = cases.elementsWith(duplicated: \.name.text)

    if duplicates.isNotEmpty {
      throw DiagnosticsError(diagnostics: duplicates.flatMap { $0 }.map {
        .init(
          node: Syntax(fromProtocol: $0),
          message: MobecanDiagnosticMessage.duplicatedEnumCaseNames
        )
      })
    }
  }
}
