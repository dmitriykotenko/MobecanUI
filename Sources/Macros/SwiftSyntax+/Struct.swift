// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct Struct: Equatable, Hashable, Codable {

  var name: String
  var genericArguments: [String]
  var storedProperties: [StoredProperty]

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
