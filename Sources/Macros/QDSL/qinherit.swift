// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Inheritance (optional)

public enum qinherit {
  
  /// `: A, B, C`
  public static func types(_ inherited: TypeSyntax...) -> InheritanceClauseSyntax {
    InheritanceClauseSyntax(
      colon: .colonToken(trailingTrivia: .space),
      inheritedTypes: InheritedTypeListSyntax(
        inherited.enumerated().map { index, type in
          InheritedTypeSyntax(
            type: type,
            trailingComma: index < inherited.count - 1 ? .commaToken(trailingTrivia: .space) : nil
          )
        }
      )
    )
  }
}
