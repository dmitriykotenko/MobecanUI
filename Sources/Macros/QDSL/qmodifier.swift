// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - switch (stmt + expression via IIFE) and patterns

public enum m {

  public static let `private` = DeclModifierSyntax(name: q.tok.keyword(.private))
  public static let `fileprivate` = DeclModifierSyntax(name: q.tok.keyword(.fileprivate))
  public static let `public` = DeclModifierSyntax(name: q.tok.keyword(.public))
  public static let `open` = DeclModifierSyntax(name: q.tok.keyword(.open))

  public static let `static` = DeclModifierSyntax(name: q.tok.keyword(.static))
}
