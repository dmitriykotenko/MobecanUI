// Sources/QDSL/QDSL.swift
//
// QDSL: a tiny, zero-parse SwiftSyntax DSL for concise, fast macro code.
// Toolchain: SwiftSyntax 510+ (works with Xcode 15.3/15.4) and Swift 5.10+.

import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - var / let and typealias decls

public enum qdecls {

  /// `var name: Type = value`
  public static func `var`(_ name: String,
                           modifiers: DeclModifierListSyntax = [],
                            _ type: TypeSyntax? = nil,
                           _ initializer: InitializerClauseSyntax? = nil) -> DeclSyntax {
    varLet(false, modifiers: modifiers, name, type, initializer)
  }

  /// `let name: Type = value`
  public static func `let`(_ name: String,
                           modifiers: DeclModifierListSyntax = [],
                           _ type: TypeSyntax? = nil,
                           _ initializer: InitializerClauseSyntax? = nil) -> DeclSyntax {
    varLet(true, modifiers: modifiers, name, type, initializer)
  }

  /// `var/let name: Type = value`
  public static func varLet(_ isLet: Bool = false,
                            modifiers: DeclModifierListSyntax = [],
                            _ name: String,
                            _ type: TypeSyntax? = nil,
                            _ initializer: InitializerClauseSyntax? = nil) -> DeclSyntax {
    DeclSyntax(
      VariableDeclSyntax(
        modifiers: modifiers,
        bindingSpecifier: .keyword(isLet ? .let : .var),
        bindings: PatternBindingListSyntax {
          PatternBindingSyntax(
            pattern: PatternSyntax(
              IdentifierPatternSyntax(identifier: q.tok.id(name))
            ),
            typeAnnotation: type.map {
              TypeAnnotationSyntax(colon: .colonToken(trailingTrivia: .space), type: $0)
            },
            initializer: initializer
          )
        }
      )
    )
  }

  public static func computedVar(_ name: String,
                                 modifiers: DeclModifierListSyntax = [],
                                 _ type: TypeSyntax? = nil,
                                 @qstmts body: () -> [CodeBlockItemSyntax]) -> DeclSyntax {
    DeclSyntax(
      VariableDeclSyntax(
        modifiers: modifiers,
        bindingSpecifier: .keyword(.var),
        bindings: PatternBindingListSyntax {
          PatternBindingSyntax(
            pattern: PatternSyntax(
              IdentifierPatternSyntax(identifier: q.tok.id(name))
            ),
            typeAnnotation: type.map {
              TypeAnnotationSyntax(colon: .colonToken(trailingTrivia: .space), type: $0)
            },
            accessorBlock: AccessorBlockSyntax(accessors: .getter(CodeBlockItemListSyntax(body())))
          )
        }
      )
    )
  }

  /// `typealias Name = Type`
  public static func `typealias`(_ name: String,
                                 modifiers: DeclModifierListSyntax,
                                 _ aliased: TypeSyntax) -> DeclSyntax {
    DeclSyntax(
      TypeAliasDeclSyntax(
        modifiers: modifiers,
        typealiasKeyword: .keyword(.typealias),
        name: q.tok.id(name),
        initializer: TypeInitializerClauseSyntax(
          equal: .equalToken(trailingTrivia: .space),
          value: aliased
        )
      )
    )
  }
}


@inlinable public func _var(_ name: String,
                            modifiers: DeclModifierListSyntax = [],
                            _ type: TypeSyntax? = nil,
                            _ initializer: InitializerClauseSyntax? = nil) -> DeclSyntax {
  qdecls.var(name, modifiers: modifiers, type, initializer)
}


@inlinable public func _computedVar(_ name: String,
                                    modifiers: DeclModifierListSyntax = [],
                                    _ type: TypeSyntax? = nil,
                                    @qstmts body: () -> [CodeBlockItemSyntax]) -> DeclSyntax {
  qdecls.computedVar(name, modifiers: modifiers, type, body: body)
}


@inlinable public func _let(_ name: String,
                            modifiers: DeclModifierListSyntax = [],
                            _ type: TypeSyntax? = nil,
                            _ initializer: InitializerClauseSyntax? = nil) -> DeclSyntax {
  qdecls.let(name, modifiers: modifiers, type, initializer)
}


@inlinable public func _typealias(_ name: String,
                                  modifiers: DeclModifierListSyntax = [],
                                  _ aliased: TypeSyntax) -> DeclSyntax {
  qdecls.typealias(
    name,
    modifiers: modifiers,
    aliased
  )
}
