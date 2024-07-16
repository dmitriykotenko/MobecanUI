// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct NominalType: Equatable, Hashable, Codable {

  var name: String
  var genericArguments: [String]

  func genericArgumentsConformanceRequirement(protocolName: String) -> String? {
    genericArguments
      .map { "\($0): \(protocolName)" }
      .mkStringWithComma()
      .notBlankOrNil
  }

  var fullName: String {
    genericArguments.isEmpty ?
      name :
      name + "<" + genericArguments.mkStringWithComma() + ">"
  }
}
