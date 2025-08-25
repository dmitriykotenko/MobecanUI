// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Trailing-closure literals

extension q {

  /// `{ (p1, p2, ...) in ... }`
  public static func closure(params: [String],
                             @qstmts body: () -> [CodeBlockItemSyntax]) -> ClosureExprSyntax {
    ClosureExprSyntax(
      signature: params.isEmpty ? nil :
        ClosureSignatureSyntax(
          leadingTrivia: .space,
          parameterClause: .parameterClause(
            ClosureParameterClauseSyntax(
              parameters: ClosureParameterListSyntax(
                params.enumerated().map { i, name in
                  ClosureParameterSyntax(
                    firstName: q.tok.id(name),
                    colon: nil,
                    trailingComma: i < params.count - 1 ? .commaToken(trailingTrivia: .space) : nil
                  )
                }
              )
            )
          ).with(\.trailingTrivia, .space),
          inKeyword: .keyword(.in),
          trailingTrivia: .newline
        ),
      statements: CodeBlockItemListSyntax(body()).with(\.trailingTrivia, .newline)
    )
  }

  /// `{ (p1, p2, ...) in ... }`
  public static func closure(params: String...,
                             @qstmts body: () -> [CodeBlockItemSyntax]) -> ClosureExprSyntax {
    closure(params: params, body: body)
  }
}

/// `{ (p1, p2, ...) in ... }`
@inlinable public func _closure(params: String...,
                                @qstmts body: () -> [CodeBlockItemSyntax]) -> ClosureExprSyntax {
  q.closure(params: params, body: body)
}



