// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Member blocks (no qmember needed)

@resultBuilder
public struct qmembers {
  
  // collect
  public static func buildBlock(_ parts: [MemberBlockItemSyntax]...) -> [MemberBlockItemSyntax] {
    parts.flatMap { $0 }
  }

  // wrap decls / stmts / exprs
  public static func buildExpression(_ d: some DeclSyntaxProtocol) -> [MemberBlockItemSyntax] {
    [MemberBlockItemSyntax(decl: d)]
  }
//
//  public static func buildExpression(_ s: StmtSyntax) -> [MemberBlockItemSyntax] {
//    [MemberBlockItemSyntax(item: .stmt(s))]
//  }
//
//  public static func buildExpression(_ e: ExprSyntax) -> [MemberBlockItemSyntax] {
//    [MemberBlockItemSyntax(item: .expr(e))]
//  }

  // convenience: accept concrete decls without forcing callers to wrap in DeclSyntax
  public static func buildExpression(_ d: StructDeclSyntax) -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }
  public static func buildExpression(_ d: ClassDeclSyntax)  -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }
  public static func buildExpression(_ d: EnumDeclSyntax)   -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }
  public static func buildExpression(_ d: FunctionDeclSyntax) -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }
  public static func buildExpression(_ d: InitializerDeclSyntax) -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }
  public static func buildExpression(_ d: VariableDeclSyntax) -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }
  public static func buildExpression(_ d: TypeAliasDeclSyntax) -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }
  public static func buildExpression(_ d: EnumCaseDeclSyntax) -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }

  // control flow sugar
  public static func buildOptional(_ c: [MemberBlockItemSyntax]?) -> [MemberBlockItemSyntax] { c ?? [] }
  public static func buildEither(first c: [MemberBlockItemSyntax]) -> [MemberBlockItemSyntax] { c }
  public static func buildEither(second c: [MemberBlockItemSyntax]) -> [MemberBlockItemSyntax] { c }

  public static func buildArray(_ components: [[MemberBlockItemSyntax]]) -> [MemberBlockItemSyntax] {
    components.flatMap { $0 }
  }
}


public func qmemberBlock(@qmembers _ make: () -> [MemberBlockItemSyntax]) -> MemberBlockSyntax {
  MemberBlockSyntax(members: MemberBlockItemListSyntax(make()))
}
