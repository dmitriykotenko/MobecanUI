// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Fluent .call(...) (unlabeled or labeled), plus trailing-closure variants

public extension ExprSyntax {

  /// `callee(arg1, arg2, ...)`
  func call(_ exprs: ExprSyntax...) -> ExprSyntax {
    call(exprs.map { qarg($0) })
  }

  /// `callee("label" <- arg, ...)`
  func call(_ args: LabeledExprSyntax...) -> ExprSyntax {
    ExprSyntax(
      FunctionCallExprSyntax(
        calledExpression: self,
        leftParen: .leftParenToken(),
        arguments: LabeledExprListSyntax(
          args.enumerated().map { index, arg in
            arg.with(\.trailingComma, args.trailingComma(forIndex: index))
          }
        ),
        rightParen: .rightParenToken()
      )
    )
  }

  func call(_ args: [LabeledExprSyntax]) -> ExprSyntax {
    ExprSyntax(
      FunctionCallExprSyntax(
        calledExpression: self,
        leftParen: .leftParenToken(),
        arguments: LabeledExprListSyntax(
          args.enumerated().map { index, arg in
            arg.with(\.trailingComma, args.trailingComma(forIndex: index))
          }
        ),
        rightParen: .rightParenToken()
      )
    )
  }

  /// `callee { ... }` (no args, trailing closure)
  func call(trailingClosure: ClosureExprSyntax) -> ExprSyntax {
    ExprSyntax(
      FunctionCallExprSyntax(
        calledExpression: self,
        leftParen: nil,
        arguments: LabeledExprListSyntax([]),
        rightParen: nil,
        trailingClosure: trailingClosure
      )
    )
  }

  /// `callee(args...) { ... }`
  func call(_ args: [LabeledExprSyntax],
            trailingClosure: ClosureExprSyntax) -> ExprSyntax {
    ExprSyntax(
      FunctionCallExprSyntax(
        calledExpression: self,
        leftParen: .leftParenToken(),
        arguments: LabeledExprListSyntax(
          args.enumerated().map { index, arg in
            arg.with(\.trailingComma, args.trailingComma(forIndex: index))
          }
        ),
        rightParen: .rightParenToken(),
        trailingClosure: trailingClosure.with(\.leadingTrivia, .space)
      )
    )
  }

  // Disambiguate empty calls like `.getFirstName()`
  func call() -> ExprSyntax {
    ExprSyntax(
      FunctionCallExprSyntax(
        calledExpression: self,
        leftParen: .leftParenToken(),
        arguments: LabeledExprListSyntax([]),
        rightParen: .rightParenToken()
      )
    )
  }
}


extension ExprSyntax {

  /// `callee(arg1, arg2, ...)`
  public func dot(_ name: String) -> ExprSyntax {
    ExprSyntax(
      MemberAccessExprSyntax(
        base: self,
        period: .periodToken(),
        declName: DeclReferenceExprSyntax(baseName: q.tok.id(name))
      )
    )
  }

  public var asForceTry: ExprSyntax {
    q.e.forceTry(self)
  }

  public func asForceTry(if condition: Bool) -> ExprSyntax {
    condition ? asForceTry : self
  }

  public var asForceUnwrapped: ExprSyntax {
    q.e.forceUnwrap(self)
  }

  public func asForceUnwrapped(if condition: Bool) -> ExprSyntax {
    condition ? asForceUnwrapped : self
  }

  public var asOptionalTry: ExprSyntax {
    q.e.optionalTry(self)
  }

  public func asTry(questionOrExclamationMark: TokenSyntax? = nil) -> ExprSyntax {
    q.e.try(questionOrExclamationMark: questionOrExclamationMark, self)
  }
}


public extension ExprSyntax {

  /// array[expr1, expr2, ...]
  func `subscript`(_ exprs: ExprSyntax...) -> ExprSyntax {
    ExprSyntax(
      SubscriptCallExprSyntax(
        calledExpression: self,
        leftSquare: .leftSquareToken(),
        arguments: LabeledExprListSyntax(exprs.map { qarg($0) }),
        rightSquare: .rightSquareToken()
      )
    )
  }

  /// dict[key: expr]
  func `subscript`(_ args: LabeledExprSyntax...) -> ExprSyntax {
    ExprSyntax(
      SubscriptCallExprSyntax(
        calledExpression: self,
        leftSquare: .leftSquareToken(),
        arguments: LabeledExprListSyntax(args),
        rightSquare: .rightSquareToken()
      )
    )
  }
}
