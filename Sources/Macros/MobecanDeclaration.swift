// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


protocol MobecanDeclaration {}


extension MobecanDeclaration {

  static func declarationOf(storedProperties: [StoredProperty]) -> String {
    storedProperties.map(\.varDeclaration).mkStringWithNewLine()
  }
}


extension MobecanDeclaration {

  static func memberwiseInitializer(storedProperties: [StoredProperty],
                                    isCompact: Bool = true) -> String {
    initializer(
      parameters: storedProperties.map { $0.asFunctionParameter() },
      isCompact: isCompact,
      body: membewiseInitializerBody(storedProperties: storedProperties)
    )
  }

  static func memberwiseInitializer(parameters: [FunctionParameter],
                                    isCompact: Bool = true) -> String {
    initializer(
      parameters: parameters,
      isCompact: isCompact,
      body: membewiseInitializerBody(
        storedProperties: parameters.compactMap(\.asStoredProperty)
      )
    )
  }

  private static func membewiseInitializerBody(storedProperties: [StoredProperty]) -> String {
    storedProperties.mkString(
      format: { "self.\($0.name) = \($0.name)" },
      separator: "\n"
    ) + .newLine + .newLine + "super.init()"
  }

  static func memberwiseInitializer(parameters: [FunctionParameter],
                                    customName: String,
                                    selfType: String,
                                    isCompact: Bool = true) -> String {
    initializer(
      parameters: parameters,
      customName: customName,
      selfType: selfType,
      isCompact: isCompact,
      body: """
      .init(
      \(parameters
        .map { [$0.unescapedOuterName, $0.innerName].filterNil().mkStringWithColon() }
        .mkStringWithCommaAndNewLine()
        .prependingToEveryLine("  ")
      )
      )
      """
      .compactifiedIfShort
    )
  }

  static func initializer(parameters: [FunctionParameter],
                          isCompact: Bool,
                          body: String) -> String {
    function(
      keywords: ["public"],
      name: "init",
      parameters: parameters,
      isCompact: isCompact,
      body: body
    )
  }

  static func initializer(parameters: [FunctionParameter],
                          customName: String,
                          selfType: String,
                          isCompact: Bool,
                          body: String) -> String {
    function(
      keywords: ["public static func"],
      name: customName,
      parameters: parameters,
      returns: "-> \(selfType)",
      isCompact: isCompact,
      body: body
    )
  }

  static func function(keywords: [String] = ["function"],
                       name: String,
                       genericParameters: [String] = [],
                       parameters: [FunctionParameter],
                       returns: String? = nil,
                       where: String? = nil,
                       isCompact: Bool = true,
                       body: String) -> String {
    let signature = FunctionSignature(
      keywords: keywords,
      name: name,
      genericParameters: genericParameters,
      parameters: parameters,
      returns: returns,
      where: `where`
    )

    return function(
      signature: signature.build(isCompact: isCompact, lineLengthThreshold: 100),
      body: body
    )
  }

  static func function(signature: FunctionSignature,
                       body: String) -> String {
    function(
      signature: signature.build(isCompact: true, lineLengthThreshold: 100), 
      body: body
    )
  }

  static func function(signature: String,
                       body: String) -> String {
    """
    \(signature) {
    \("  ".prependingToLines(of: body))
    }
    """
  }
}
