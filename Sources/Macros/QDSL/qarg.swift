// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Arguments + labeled-arg operator

public func qarg(_ expr: ExprSyntax,
                 comma: Bool = false) -> LabeledExprSyntax {
  LabeledExprSyntax(
    expression: expr,
    trailingComma: comma ? .commaToken(trailingTrivia: .space) : nil
  )
}

public func qarg(_ label: String?,
                 _ expr: ExprSyntax,
                 comma: Bool = false) -> LabeledExprSyntax {
  qarg(
    label.map { q.tok.id($0) },
    expr,
    comma: comma
  )
}

public func qarg(_ label: TokenSyntax?,
                 _ expr: ExprSyntax,
                 comma: Bool = false) -> LabeledExprSyntax {
  LabeledExprSyntax(
    label: label,
    colon: label == nil ? nil : .colonToken(trailingTrivia: .space),
    expression: expr,
    trailingComma: comma ? .commaToken(trailingTrivia: .space) : nil
  )
}

/// `"from" <- expr` → a labeled argument.
precedencegroup qLabelPrecedence { higherThan: AssignmentPrecedence }
infix operator <- : qLabelPrecedence
prefix operator <--

@discardableResult
public func <- (label: String?, expr: ExprSyntax) -> LabeledExprSyntax { qarg(label, expr) }

@discardableResult
public func <- (label: TokenSyntax?, expr: ExprSyntax) -> LabeledExprSyntax { qarg(label, expr) }

@discardableResult
public prefix func <-- (expr: ExprSyntax) -> LabeledExprSyntax { qarg( expr) }

@discardableResult
public func <- (label: TokenSyntax,
                type: TypeSyntax) -> FunctionParameterSyntax {
  q.funcParam(label, type)
}

@discardableResult
public func <- (label: TokenSyntax?,
                 type: TypeSyntax) -> EnumCaseParameterSyntax {
  q.enumParam(label, type)
}



@discardableResult
public func <- (key: ExprSyntax,
                value: ExprSyntax) -> DictionaryElementSyntax {
  qdictionary_elements.element(key, value)
}
