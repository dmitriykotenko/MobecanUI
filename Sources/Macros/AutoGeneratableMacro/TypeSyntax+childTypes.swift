// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension TypeSyntax {

  var childTypes: [TypeSyntax] {
    genericArguments
    ?? wrappedType.map { [$0] }
    ?? elementType.map { [$0] }
    ?? keyAndValueTypes
    ?? baseType.map { [$0] }
    ?? someOrAnyTypeConstraint.map { [$0] }
    ?? []
  }

  var genericArguments: [TypeSyntax]? {
    self.as(IdentifierTypeSyntax.self)?
      .genericArgumentClause?
      .arguments
      .map(\.argument)
  }

  var wrappedType: TypeSyntax? {
    self.as(OptionalTypeSyntax.self)?.wrappedType
    ?? self.as(ImplicitlyUnwrappedOptionalTypeSyntax.self)?.wrappedType
  }

  var elementType: TypeSyntax? {
    self.as(ArrayTypeSyntax.self)?.element
  }

  var keyAndValueTypes: [TypeSyntax]? {
    (self.as(DictionaryTypeSyntax.self)).map { [$0.key, $0.value] }
  }

  var baseType: TypeSyntax? {
    self.as(AttributedTypeSyntax.self)?.baseType
    ?? self.as(MemberTypeSyntax.self)?.baseType
  }

  var someOrAnyTypeConstraint: TypeSyntax? {
    self.as(SomeOrAnyTypeSyntax.self)?.constraint
  }

  var withAllNestedTypes: [TypeSyntax] {
    [self] + childTypes.flatMap(\.withAllNestedTypes)
  }
}
