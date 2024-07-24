// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct Struct: Equatable, Hashable, Codable {

  var visibilityModifiers: [String]
  var name: String
  var genericArguments: [String]
  var storedProperties: [StoredProperty]

  var visibilityPrefix: String {
    visibilityModifiers.isEmpty ? "" : visibilityModifiers.mkStringWithComma() + " "
  }

  var implicitInitializer: Function {
    let parameters = parametersOfImplicitInitializer

    return .init(
      signature: .init(
        keywords: [],
        name: "init",
        parameters: parameters
      ),
      body: """
      \(parameters
        .compactMap(\.innerName)
        .map { "self.\($0) = \($0)" }
        .mkStringWithNewLine()
      )
      """
    )
  }

  var parametersOfImplicitInitializer: [FunctionParameter] {
    storedProperties.filter(\.canBeInitialized).map {
      $0.asFunctionParameter(
        defaultValue: $0.type.hasSuffix("?") ? "nil" : $0.defaultValue
      )
    }
  }

  var asNominalType: NominalType {
    .init(
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
