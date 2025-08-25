// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


extension Collection {

  func trailingComma(forIndex index: Int) -> TokenSyntax? {
    index < (count - 1) ? .commaToken(trailingTrivia: .space) : nil
  }
}
