// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct Enum: Equatable, Hashable, Codable {

  var visibilityModifiers: [String]
  var name: String
  var genericArguments: [String]
  var cases: [EnumCase]

  var nonTrivialCases: [EnumCase] {
    cases.filter(\.parameters.isNotEmpty)
  }

  var isPrimitive: Bool { nonTrivialCases.isEmpty }

  var withoutAccociatedValues: Self {
    var result = self
    result.cases = result.cases.map(\.withoutParameters)
    return result
  }

  func with(name: String) -> Self {
    var result = self
    result.name = name
    return result
  }

  var asNominalType: NominalType {
    .init(
      name: name,
      genericArguments: genericArguments
    )
  }

  func declaration(inheritedProtocols: [String]) -> String {
    """
    enum \(name): \(inheritedProtocols.mkStringWithComma()) {
    \("  ".prependingToLines(of: casesDeclaration))
    }
    """
  }

  var casesDeclaration: String {
    cases.map(\.declaration).mkStringWithNewLine()
  }

  func genericArgumentsConformanceRequirement(protocolName: String) -> String? {
    genericArguments.map { "\($0): \(protocolName)" }
      .mkStringWithComma()
      .notBlankOrNil
  }
}
