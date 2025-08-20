// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


/// Добавляет дефолтный конструктор,
/// заполняющий все поля класса или структуры и имеющий такую же видимость,
/// как и сам класс или сама структура.
public struct MemberwiseInitMacro2 {}


extension MemberwiseInitMacro2: MemberMacro, MobecanDeclaration {

  public static func expansion(of node: AttributeSyntax,
                               providingMembersOf declaration: some DeclGroupSyntax,
                               conformingTo protocols: [TypeSyntax],
                               in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    return logMacroPerformance("MemberwiseInitMacro.expansion.2") {
      let initializer = declaration
        .macroGeneratedMemberwiseInitializer2

      return initializer.asSequence.map { DeclSyntax($0) }
    }
  }
}

extension MemberwiseType {

  func buildMemberwiseInitializer2() -> InitializerDeclSyntax {
    InitializerDeclSyntax(
      modifiers: .init(visibilityPrefix2),
      initKeyword: .keyword(.`init`),
      signature: FunctionSignatureSyntax(
        parameterClause: FunctionParameterClauseSyntax(
          parameters: FunctionParameterListSyntax {
            for p in storedProperties where p.canBeInitialized {
              FunctionParameterSyntax(
                leadingTrivia: .newline,
                firstName: p.name,
                colon: .colonToken(),
                type: p.typeDeclWithEscapingIfNecessary,
                defaultValue: p.defaultValueDecl ?? p.implicitDefaultValueDecl,
                trailingComma: .commaToken()
              )
            }
          }
        )
      ),
      body: CodeBlockSyntax(
        leftBrace: .leftBraceToken(),
        statements: CodeBlockItemListSyntax {
          for p in storedProperties where p.canBeInitialized {
            CodeBlockItemSyntax(
              item: .expr(
                ExprSyntax(SequenceExprSyntax {
                  ExprSyntax(MemberAccessExprSyntax(
                    base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                    period: .periodToken(),
                    declName: DeclReferenceExprSyntax(baseName: p.name)
                  ))
                  ExprSyntax(AssignmentExprSyntax(equal: .equalToken()))
                  ExprSyntax(DeclReferenceExprSyntax(baseName: p.name))
                })
              )
            )
          }
        },
        rightBrace: .rightBraceToken()
      )
    )
  }

  func buildMemberwiseInitializer() -> InitializerDeclSyntax {

    let params = FunctionParameterListSyntax(
      storedProperties.compactMap { p -> FunctionParameterSyntax? in
        guard p.canBeInitialized else { return nil }
        return FunctionParameterSyntax(
          // attrs/modifiers default to nil
          firstName: p.name,
          // secondName: nil,
          colon: .colonToken(),
          type: p.typeDeclWithEscapingIfNecessary, // keep as TypeSyntax (don’t stringify)
          // ellipsis: nil,
          defaultValue: p.defaultValueDecl ?? p.implicitDefaultValueDecl, // InitializerClauseSyntax? (or nil)
          trailingComma: .commaToken(trailingTrivia: .space)
//          trailingComma: idx < storedProperties.count - 1 ? .commaToken(trailingTrivia: .space) : nil
        )
      }
    )

    // --- body: self.x = x (array-based as well) ---
    let bodyStmts = CodeBlockItemListSyntax(
      storedProperties.compactMap { p -> CodeBlockItemSyntax? in
        guard p.canBeInitialized else { return nil }
        let left = MemberAccessExprSyntax(
          base: DeclReferenceExprSyntax(baseName: .identifier("self")),
          period: .periodToken(),
          declName: DeclReferenceExprSyntax(baseName: p.name)
        )
        let assign = SequenceExprSyntax {
          ExprSyntax(left)
          ExprSyntax(AssignmentExprSyntax(equal: .equalToken()))
          ExprSyntax(DeclReferenceExprSyntax(baseName: p.name))
        }
        return CodeBlockItemSyntax(item: .expr(ExprSyntax(assign)))
      }
    )

    return InitializerDeclSyntax(
      modifiers: .init(visibilityPrefix2), // if you have them
      initKeyword: .keyword(.`init`),
      signature: FunctionSignatureSyntax(
        parameterClause: FunctionParameterClauseSyntax(parameters: params)
      ),
      body: CodeBlockSyntax(
        leftBrace: .leftBraceToken(),
        statements: bodyStmts,
        rightBrace: .rightBraceToken()
      )
    )
  }
}
