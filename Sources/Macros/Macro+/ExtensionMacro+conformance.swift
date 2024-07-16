// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension ExtensionMacro {

  static func recursiveConformance(of type: NominalType,
                                   to protocolName: String,
                                   body: String? = nil) -> ExtensionDeclSyntax {
    conformance(
      ofTypeString: type.name,
      to: protocolName,
      where: type.genericArgumentsConformanceRequirement(protocolName: protocolName),
      body: body
    )
  }

  static func conformance(of type: some TypeSyntaxProtocol,
                          to protocolName: String,
                          where genericArgumentsCondition: String? = nil,
                          body: String? = nil) -> ExtensionDeclSyntax {
    conformance(
      ofTypeString: type.trimmedDescription,
      to: protocolName,
      where: genericArgumentsCondition,
      body: body
    )
  }

  static func conformance(ofTypeString typeString: String,
                          to protocolName: String,
                          where genericArgumentsCondition: String? = nil,
                          body: String? = nil) -> ExtensionDeclSyntax {
    let header = [
        "extension \(typeString): \(protocolName)",
        "where ".prependTo(genericArgumentsCondition?.notBlankOrNil)
      ]
      .filterNil()
      .mkStringWithNewLine()
      .asSingleLineIfShort()

    let bodyDeclaration = body?
      .asCodeBlock(
        startDelimiter: .newLine + .newLine, 
        endDelimiter: .newLine,
        indentation: "  "
      )
      ?? "{}"

    return DeclSyntax(
      """
      \(raw: header) \(raw: bodyDeclaration)
      """
    )
    .cast(ExtensionDeclSyntax.self)
  }
}
