// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Type declarations: struct / class / enum

extension q {

  public static func `struct`(
    _ name: String,
    modifiers: DeclModifierListSyntax = [],
    generics: GenericParameterClauseSyntax? = nil,
    inherits: InheritanceClauseSyntax? = nil,
    where whereClause: GenericWhereClauseSyntax? = nil,
    @qmembers _ members: () -> [MemberBlockItemSyntax]
  ) -> StructDeclSyntax {
    StructDeclSyntax(
      modifiers: modifiers,
      structKeyword: .keyword(.struct),
      name: q.tok.id(name),
      genericParameterClause: generics,
      inheritanceClause: inherits,
      genericWhereClause: whereClause,
      memberBlock: qmemberBlock(members)
    )
  }

  public static func `class`(
    _ name: String,
    modifiers: DeclModifierListSyntax = [],
    generics: GenericParameterClauseSyntax? = nil,
    inherits: InheritanceClauseSyntax? = nil,
    where whereClause: GenericWhereClauseSyntax? = nil,
    @qmembers _ members: () -> [MemberBlockItemSyntax]
  ) -> ClassDeclSyntax {
    ClassDeclSyntax(
      modifiers: modifiers,
      classKeyword: .keyword(.class),
      name: q.tok.id(name),
      genericParameterClause: generics,
      inheritanceClause: inherits,
      genericWhereClause: whereClause,
      memberBlock: qmemberBlock(members)
    )
  }

  public static func `enum`(
    _ name: String,
    modifiers: DeclModifierListSyntax = [],
    generics: GenericParameterClauseSyntax? = nil,
    inherits: InheritanceClauseSyntax? = nil,
    where whereClause: GenericWhereClauseSyntax? = nil,
    @qmembers _ members: () -> [MemberBlockItemSyntax]
  ) -> EnumDeclSyntax {
    EnumDeclSyntax(
      modifiers: modifiers,
      enumKeyword: .keyword(.enum),
      name: q.tok.id(name),
      genericParameterClause: generics,
      inheritanceClause: inherits,
      genericWhereClause: whereClause,
      memberBlock: qmemberBlock(members)
    )
  }
}


@inlinable public func _struct(
  _ name: String,
  modifiers: DeclModifierListSyntax = [],
  generics: GenericParameterClauseSyntax? = nil,
  inherits: InheritanceClauseSyntax? = nil,
  where whereClause: GenericWhereClauseSyntax? = nil,
  @qmembers _ members: () -> [MemberBlockItemSyntax]
) -> StructDeclSyntax {
  q.struct(
    name,
    modifiers: modifiers,
    generics: generics,
    inherits: inherits,
    where: whereClause,
    members
  )
}

@inlinable public func _class(
  _ name: String,
  modifiers: DeclModifierListSyntax = [],
  generics: GenericParameterClauseSyntax? = nil,
  inherits: InheritanceClauseSyntax? = nil,
  where whereClause: GenericWhereClauseSyntax? = nil,
  @qmembers _ members: () -> [MemberBlockItemSyntax]
) -> ClassDeclSyntax {
  q.class(
    name,
    modifiers: modifiers,
    generics: generics,
    inherits: inherits,
    where: whereClause,
    members
  )
}

@inlinable public func _enum(
  _ name: String,
  modifiers: DeclModifierListSyntax = [],
  generics: GenericParameterClauseSyntax? = nil,
  inherits: InheritanceClauseSyntax? = nil,
  where whereClause: GenericWhereClauseSyntax? = nil,
  @qmembers _ members: () -> [MemberBlockItemSyntax]
) -> EnumDeclSyntax {
  q.enum(
    name,
    modifiers: modifiers,
    generics: generics,
    inherits: inherits,
    where: whereClause,
    members
  )
}
