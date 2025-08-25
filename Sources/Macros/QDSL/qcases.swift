// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Switch case builder (so cases live inside braces)

@resultBuilder
public struct qcases {

  public static func buildBlock(_ parts: [SwitchCaseSyntax]...) -> [SwitchCaseSyntax] {
    parts.flatMap { $0 }
  }

  public static func buildExpression(_ c: SwitchCaseSyntax) -> [SwitchCaseSyntax] { [c] }

  // control-flow support inside the builder
  public static func buildOptional(_ c: [SwitchCaseSyntax]?) -> [SwitchCaseSyntax] { c ?? [] }
  public static func buildEither(first c: [SwitchCaseSyntax]) -> [SwitchCaseSyntax] { c }
  public static func buildEither(second c: [SwitchCaseSyntax]) -> [SwitchCaseSyntax] { c }

  public static func buildArray(_ chunks: [[SwitchCaseSyntax]]) -> [SwitchCaseSyntax] {
    chunks.flatMap { $0 }
  }

  public static func buildFinalResult(_ components: [SwitchCaseSyntax]) -> [SwitchCaseSyntax] {
    components.enumerated().map { index, component in
      component
        .with(\.leadingTrivia, .newline)
        .with(\.trailingTrivia, index == components.count - 1 ? .newline : .space)
    }
  }
}
