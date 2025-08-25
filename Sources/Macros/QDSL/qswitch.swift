// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - switch (stmt + expression via IIFE) and patterns

public enum qswitch {
  
  /// case patternList: { body }
  public static func `case`(_ patterns: PatternSyntax...,
                            @qstmts then body: () -> [CodeBlockItemSyntax]) -> SwitchCaseSyntax {
    SwitchCaseSyntax(
      label: .case(
        SwitchCaseLabelSyntax(
          caseKeyword: .keyword(.case),
          caseItems: SwitchCaseItemListSyntax(
            patterns.enumerated().map { i, p in
              SwitchCaseItemSyntax(
                pattern: p,
                trailingComma: i < patterns.count - 1 ? .commaToken(trailingTrivia: .space) : nil
              )
            }
          ).with(\.leadingTrivia, .space),
          colon: .colonToken()
        )
      ),
      statements: CodeBlockItemListSyntax(body()).with(\.leadingTrivia, .space)
    )
  }

  /// default: { body }
  public static func `default`(@qstmts _ body: () -> [CodeBlockItemSyntax]) -> SwitchCaseSyntax {
    SwitchCaseSyntax(
      label: .default( SwitchDefaultLabelSyntax(defaultKeyword: .keyword(.default), colon: .colonToken()) ),
      statements:
        CodeBlockItemListSyntax(body()).with(\.leadingTrivia, .space)
    )
  }

  /// switch statement
  public static func expr(_ subject: ExprSyntax,
                          @qcases _ makeCases: () -> [SwitchCaseSyntax]) -> ExprSyntax {
    ExprSyntax(
      SwitchExprSyntax(
        switchKeyword: .keyword(.switch),
        subject: subject.with(\.leadingTrivia, .space).with(\.trailingTrivia, .space),
        leftBrace: .leftBraceToken(),
        cases: SwitchCaseListSyntax(makeCases().map { .switchCase($0) }),
        rightBrace: .rightBraceToken()
      )
    )
  }
//
//  /// "switch expression" via IIFE: `{ switch … { … } }()`
//  public static func exprIIFE(_ subject: ExprSyntax, cases: [SwitchCaseSyntax]) -> ExprSyntax {
//    let switchItem = CodeBlockItemSyntax(item: .stmt( qswitch.stmt(subject, cases: cases) ))
//    let closure = ExprSyntax( ClosureExprSyntax(statements: CodeBlockItemListSyntax([switchItem])) )
//    return ExprSyntax( FunctionCallExprSyntax(
//      calledExpression: closure,
//      leftParen: .leftParenToken(),
//      rightParen: .rightParenToken()
//    ) )
//  }
}


public enum qpat {
  
  /// identifier pattern: `someName`
  public static func id(_ name: String) -> PatternSyntax {
    PatternSyntax( IdentifierPatternSyntax(identifier: q.tok.id(name)) )
  }

  /// wildcard pattern: `_`
  public static func wildcard() -> PatternSyntax {
    PatternSyntax( WildcardPatternSyntax(wildcard: .wildcardToken()) )
  }

  /// enum case (no associated values): `.caseName`
  public static func enumCase(_ caseName: String) -> PatternSyntax {
    PatternSyntax( ExpressionPatternSyntax(expression: q.e.dot(caseName)) )
  }
  // Note: for associated values, compose a TuplePatternSyntax around subpatterns.
}


/// switch statement
@inlinable public func _switch(_ subject: ExprSyntax,
                               @qcases _ makeCases: () -> [SwitchCaseSyntax]) -> ExprSyntax {
  qswitch.expr(subject, makeCases)
}
