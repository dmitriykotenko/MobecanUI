// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Statement builders

@resultBuilder
public struct qstmts {

  // collect: flatten nested arrays coming from subexpressions/branches
  public static func buildBlock(_ parts: [CodeBlockItemSyntax]...) -> [CodeBlockItemSyntax] {
    parts.flatMap { $0 }
  }

  // allow expressions as statements
  public static func buildExpression<E: ExprSyntaxProtocol>(_ e: E) -> [CodeBlockItemSyntax] {
    [CodeBlockItemSyntax(item: .expr(ExprSyntax(e)))]
  }

  // allow statements directly
  public static func buildExpression<S: StmtSyntaxProtocol>(_ s: S) -> [CodeBlockItemSyntax] {
    [CodeBlockItemSyntax(item: .stmt(StmtSyntax(s)))]
  }

  // allow declarations directly (e.g. `let x = ...` inside local scope, or nested decls in bodies)
  public static func buildExpression<D: DeclSyntaxProtocol>(_ d: D) -> [CodeBlockItemSyntax] {
    [CodeBlockItemSyntax(item: .decl(DeclSyntax(d)))]
  }

  // control-flow sugar so `if`/`guard`/`for` inside builders just work
  public static func buildOptional(_ c: [CodeBlockItemSyntax]?) -> [CodeBlockItemSyntax] { c ?? [] }
  public static func buildEither(first c: [CodeBlockItemSyntax]) -> [CodeBlockItemSyntax] { c }
  public static func buildEither(second c: [CodeBlockItemSyntax]) -> [CodeBlockItemSyntax] { c }
  public static func buildArray(_ chunks: [[CodeBlockItemSyntax]]) -> [CodeBlockItemSyntax] {
    chunks.flatMap { $0 }
  }

  // availability branches
  public static func buildLimitedAvailability(_ c: [CodeBlockItemSyntax]) -> [CodeBlockItemSyntax] { c }
}


public func qexpr(_ e: ExprSyntax) -> CodeBlockItemSyntax { CodeBlockItemSyntax(item: .expr(e)) }

public func qreturn(_ e: ExprSyntax) -> CodeBlockItemSyntax {
  CodeBlockItemSyntax(
    item: .stmt(StmtSyntax(
      ReturnStmtSyntax(
        returnKeyword: .keyword(.return),
        expression: e
      )
    ))
  )
}

extension q {
  
  public static func `return`(_ e: ExprSyntax) -> ReturnStmtSyntax {
    ReturnStmtSyntax(
      returnKeyword: .keyword(.return),
      expression: e.with(\.leadingTrivia, .space)
    )
  }
}

public func qbody(@qstmts _ make: () -> [CodeBlockItemSyntax]) -> CodeBlockSyntax {
  CodeBlockSyntax(statements: CodeBlockItemListSyntax(make()))
}


@inlinable public func _return(_ e: ExprSyntax) -> ReturnStmtSyntax {
  q.return(e)
}
