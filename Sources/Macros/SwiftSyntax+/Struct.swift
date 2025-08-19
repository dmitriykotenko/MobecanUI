// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct Struct: Equatable, Hashable, Codable, Lensable {

  var visibilityModifiers: [VisibilityModifier]
  var name: String
  var genericArguments: [String]
  var storedProperties: [StoredProperty]


  var visibilityPrefix: String {
    visibilityModifiers.isEmpty ? "" : visibilityModifiers.mkStringWithComma() + " "
  }

  var inferredMemberwiseInitializer: Function {
    .memberwiseInit(storedProperties: storedProperties)
  }

  var asNominalType: NominalType {
    .init(
      visibilityModifiers: visibilityModifiers,
      name: name,
      genericArguments: genericArguments
    )
  }

  var asProductType: ProductType {
    .init(
      nominalName: name,
      members: storedProperties.map {
        .init(
          initializationName: $0.name,
          name: $0.name,
          type: $0.type
        )
      }
    )
  }

  func genericArgumentsConformanceRequirement(protocolName: String) -> String? {
    genericArguments.map { "\($0): \(protocolName)" }
      .mkStringWithComma()
      .notBlankOrNil
  }
}


struct Struct2: Equatable, Hashable, Lensable {

  var visibilityModifiers: [DeclModifierSyntax]
  var name: TokenSyntax
  var genericArguments: GenericParameterClauseSyntax?
  var storedProperties: [StoredProperty2]

  var visibilityPrefix2: [DeclModifierSyntax] {
    visibilityModifiers.compactMap(\.asMemberwiseInitVisibilityModifier)
  }
//
//  var asNominalType: NominalType {
//    .init(
//      visibilityModifiers: visibilityModifiers,
//      name: name,
//      genericArguments: genericArguments
//    )
//  }

  func genericArgumentsConformanceRequirement2(protocolName: String) -> String? {
    (genericArguments?.parameters.map(\.name.text) ?? [])
      .map { "\($0): \(protocolName)" }
      .mkStringWithComma()
      .notBlankOrNil
  }
}
