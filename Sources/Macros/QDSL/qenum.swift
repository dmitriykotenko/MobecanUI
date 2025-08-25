// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Enum cases

extension q {
  
  /// `case name`
  public static func `case`(_ name: String) -> DeclSyntax {
    DeclSyntax(
      EnumCaseDeclSyntax(
        caseKeyword: .keyword(.case),
        elements: EnumCaseElementListSyntax([
          EnumCaseElementSyntax(name: q.tok.id(name))
        ])
      )
    )
  }

  /// `case name1, name2, ...`
  public static func cases(_ names: String...) -> DeclSyntax {
    DeclSyntax(
      EnumCaseDeclSyntax(
        caseKeyword: .keyword(.case),
        elements: EnumCaseElementListSyntax(
          names.enumerated().map { index, name in
            EnumCaseElementSyntax(
              name: q.tok.id(name),
              trailingComma: index < names.count - 1 ? .commaToken(trailingTrivia: .space) : nil
            )
          }
        )
      )
    )
  }

  /// `case name(AssociatedType, ...)`
  public static func `case`(_ name: String,
                            parameterTypes: [TypeSyntax]) -> DeclSyntax {
    self.case(
      name,
      parameters: parameterTypes.map { EnumCaseParameterSyntax(firstName: nil, type: $0) }
    )
  }

  /// `case name(AssociatedType, ...)`
  public static func `case`(_ name: String,
                            parameters: [EnumCaseParameterSyntax]) -> DeclSyntax {
    DeclSyntax(
      EnumCaseDeclSyntax(
        caseKeyword: .keyword(.case),
        elements: EnumCaseElementListSyntax([
          EnumCaseElementSyntax(
            name: q.tok.id(name),
            parameterClause: EnumCaseParameterClauseSyntax(
              leftParen: .leftParenToken(),
              parameters: EnumCaseParameterListSyntax(
                parameters.enumerated().map { index, parameter in
                  parameter.with(
                    \.trailingComma,
                    index < parameters.count - 1 ? .commaToken(trailingTrivia: .space) : nil
                  )
                }
              ),
              rightParen: .rightParenToken()
            )
          )
        ])
      )
    )
  }
}
