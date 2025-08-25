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
public struct qdictionary_elements {

  public static func element(_ key: ExprSyntax,
                             _ value: ExprSyntax) -> DictionaryElementSyntax {
    .init(
      key: key,
      colon: .colonToken(trailingTrivia: .space),
      value: value
    )
  }

  // collect: flatten nested arrays coming from subexpressions/branches
  public static func buildBlock(_ parts: [DictionaryElementSyntax]...) -> [DictionaryElementSyntax] {
    parts.flatMap { $0 }
  }

  // allow expressions as statements
  public static func buildExpression(_ element: DictionaryElementSyntax) -> [DictionaryElementSyntax] {
    [element]
  }

  // control-flow sugar so `if`/`guard`/`for` inside builders just work
  public static func buildOptional(_ c: [DictionaryElementSyntax]?) -> [DictionaryElementSyntax] { c ?? [] }
  public static func buildEither(first c: [DictionaryElementSyntax]) -> [DictionaryElementSyntax] { c }
  public static func buildEither(second c: [DictionaryElementSyntax]) -> [DictionaryElementSyntax] { c }

  public static func buildArray(_ chunks: [[DictionaryElementSyntax]]) -> [DictionaryElementSyntax] {
    chunks.flatMap { $0 }
  }

  public static func buildFinalResult(_ components: [DictionaryElementSyntax]) -> [DictionaryElementSyntax] {
    components.enumerated().map { index, element in
      element
        .with(\.leadingTrivia, .newline)
        .with(\.trailingComma, components.trailingComma(forIndex: index))
        .with(\.trailingTrivia, index == components.count - 1 ? .newline : .space)
    }
  }

  // availability branches
  public static func buildLimitedAvailability(_ c: [DictionaryElementSyntax]) -> [DictionaryElementSyntax] { c }
}
