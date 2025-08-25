// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


public enum qif {

  /// case patternList: { body }
  public static func `case`(_ patterns: [PatternSyntax],
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

  /// case patternList: { body }
  public static func `case`(_ patterns: PatternSyntax...,
                            @qstmts then body: () -> [CodeBlockItemSyntax]) -> SwitchCaseSyntax {
    self.case(patterns, then: body)
  }

  /// default: { body }
  public static func `default`(@qstmts _ body: () -> [CodeBlockItemSyntax]) -> SwitchCaseSyntax {
    SwitchCaseSyntax(
      label: .default( SwitchDefaultLabelSyntax(defaultKeyword: .keyword(.default), colon: .colonToken()) ),
      statements:
        CodeBlockItemListSyntax(body()).with(\.leadingTrivia, .space)
    )
  }

  public static func expr(_ condition: [ConditionElementSyntax],
                          @qstmts makeBody: () -> [CodeBlockItemSyntax]) -> ExprSyntax {
    ExprSyntax(
      IfExprSyntax(
        conditions: .init(condition),
        body: qbody(makeBody)
      )
    )
  }

  public static func expr(_ condition: ConditionElementSyntax...,
                          @qstmts makeBody: () -> [CodeBlockItemSyntax]) -> ExprSyntax {
    expr(condition, makeBody: makeBody)
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


extension q {

  /// `if let ...` statement
  public static func ifLet(_ name: String,
                           _ value: ExprSyntax,
                           @qstmts makeBody: () -> [CodeBlockItemSyntax]) -> ExprSyntax {
    qif.expr(
      q.condition.letBind(name, value),
      makeBody: makeBody
    )
  }
}

/// `if let ...` statement
@inlinable public func _ifLet(_ name: String,
                              _ value: ExprSyntax,
                              @qstmts makeBody: () -> [CodeBlockItemSyntax]) -> ExprSyntax {
  q.ifLet(name, value, makeBody: makeBody)
}



@inlinable public func _if(_ condition: ConditionElementSyntax...,
                           @qstmts makeBody: () -> [CodeBlockItemSyntax]) -> ExprSyntax {
  qif.expr(condition, makeBody: makeBody)
}



/// case patternList: { body }
@inlinable public func _case(_ patterns: PatternSyntax...,
                          @qstmts then body: () -> [CodeBlockItemSyntax]) -> SwitchCaseSyntax {
  qif.case(patterns, then: body)
}


/// default: { body }
@inlinable public func _default(@qstmts _ body: () -> [CodeBlockItemSyntax]) -> SwitchCaseSyntax {
  qif.default(body)
}
