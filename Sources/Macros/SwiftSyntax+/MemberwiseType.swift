// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


protocol MemberwiseType {

  var visibilityModifiers: [DeclModifierSyntax] { get }
  var name: TokenSyntax { get }
  var genericArguments: GenericParameterClauseSyntax? { get }
  var storedProperties: [StoredProperty2] { get }
}


extension MemberwiseType {

  var visibilityPrefix2: [DeclModifierSyntax] {
    visibilityModifiers.compactMap(\.asMemberwiseInitVisibilityModifier)
  }

  var visibilityPrefix3: DeclModifierListSyntax {
    .init(
      visibilityModifiers.compactMap(\.asMemberwiseInitVisibilityModifier)
    )
  }

  func genericArgumentsConformanceRequirement2(protocolName: String) -> String? {
    (genericArguments?.parameters.map(\.name.text) ?? [])
      .map { "\($0): \(protocolName)" }
      .mkStringWithComma()
      .notBlankOrNil
  }
}
