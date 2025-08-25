// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Defaults (= expr) as InitializerClauseSyntax

prefix operator ^=
infix operator ^==: AssignmentPrecedence

@inlinable
public prefix func ^= (value: ExprSyntax) -> InitializerClauseSyntax {
  InitializerClauseSyntax(equal: .equalToken(), value: value)
}


extension ExprSyntax {

  @inlinable
  public static func ^== (this: ExprSyntax,
                          that: ExprSyntax) -> ExprSyntax {
    q.e.assign(this, that)
  }
}


extension FunctionParameterSyntax {

  @inlinable
  public static func ^== (param: FunctionParameterSyntax,
                         value: ExprSyntax?) -> FunctionParameterSyntax {
    param.with(
      \.defaultValue,
       value.map { InitializerClauseSyntax(equal: .equalToken(), value: $0) }
    )
  }
}


extension EnumCaseParameterSyntax {

  @inlinable
  public static func ^== (param: EnumCaseParameterSyntax,
                         value: ExprSyntax?) -> EnumCaseParameterSyntax {
    param.with(
      \.defaultValue,
       value.map { InitializerClauseSyntax(equal: .equalToken(), value: $0) }
    )
  }
}
