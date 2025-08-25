// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - guard

extension q {

  /// `guard <conditions> else { body }`
  public static func `guard`(_ conditions: ConditionElementSyntax...,
                             @qstmts else body: () -> [CodeBlockItemSyntax]) -> StmtSyntax {
    StmtSyntax(
      GuardStmtSyntax(
        guardKeyword: .keyword(.guard),
        conditions: ConditionElementListSyntax(conditions),
        elseKeyword: .keyword(.else),
        body: CodeBlockSyntax(statements: CodeBlockItemListSyntax(body()))
      )
    )
  }
}


extension q {
  
  public enum condition {

    /// `guard let name = value else { ... }`
    /// `if let name = value { ... }`
    public static func letBind(_ name: String,
                               _ value: ExprSyntax) -> ConditionElementSyntax {
      ConditionElementSyntax(
        condition: .optionalBinding(
          OptionalBindingConditionSyntax(
            bindingSpecifier: .keyword(.let),
            pattern: PatternSyntax(IdentifierPatternSyntax(identifier: q.tok.id(name))),
            initializer: InitializerClauseSyntax(equal: .equalToken(), value: value)
          )
        )
      )
    }

    /// `guard condition else { ... }`
    /// `if condition { ... }`
    public static func boolean(_ expr: ExprSyntax) -> ConditionElementSyntax {
      ConditionElementSyntax(condition: .expression(expr))
    }
  }
}
