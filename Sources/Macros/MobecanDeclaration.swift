// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


protocol MobecanDeclaration {}


extension MobecanDeclaration {

  func declarationOf(storedProperties: [StoredProperty]) -> String {
    """
    \(storedProperties.mkString(format: { "var \($0.name): \($0.type)" }, separator: .newLine))
    """
  }

  func memberwiseInitializer(storedProperties: [StoredProperty],
                             isCompact: Bool = true) -> String {
    initializer(
      arguments: storedProperties.map { $0.asFunctionParameter() },
      isCompact: isCompact,
      body: initializerBody(storedProperties: storedProperties)
    )
  }

  func memberwiseInitializer(parameters: [FunctionParameter],
                             isCompact: Bool = true) -> String {
    initializer(
      arguments: parameters,
      isCompact: isCompact,
      body: initializerBody(storedProperties: parameters.compactMap(\.asStoredProperty))
    )
  }

  func memberwiseInitializer(parameters: [FunctionParameter],
                             customName: String,
                             selfType: String,
                             isCompact: Bool = true) -> String {
    initializer(
      arguments: parameters,
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

  func initializer(arguments: [FunctionParameter],
                   isCompact: Bool,
                   body: String) -> String {
    function(
      keywords: ["public"],
      name: "init",
      arguments: arguments,
      isCompact: isCompact,
      body: body
    )
  }

  func initializer(arguments: [FunctionParameter],
                   customName: String,
                   selfType: String,
                   isCompact: Bool,
                   body: String) -> String {
    function(
      keywords: ["public static func"],
      name: customName,
      arguments: arguments,
      returns: "-> \(selfType)",
      isCompact: isCompact,
      body: body
    )
  }

  func function(keywords: [String] = ["function"],
                name: String,
                arguments: [FunctionParameter],
                returns: String? = nil,
                isCompact: Bool = true,
                body: String) -> String {
    function(
      signature: functionSignature(
        title: (keywords + [name]).mkString(separator: " "),
        arguments: arguments,
        returns: returns,
        isCompact: isCompact
      ),
      body: body
    )
  }

  func function(signature: String,
                body: String) -> String {
    """
    \(signature) {
    \("  ".prependingToLines(of: body))
    }
    """
  }

  func functionSignature(title: String,
                         arguments: [FunctionParameter],
                         returns: String? = nil,
                         isCompact: Bool) -> String {
    let indentationForCompactForm = String(repeating: " ", count: title.count + 1)

    let compactForm = arguments.mkString(
      start: title + "(",
      format: { "\($0.declaration)" },
      separator: ",\n\(indentationForCompactForm)",
      end: ")" + (" ".prependTo(returns) ?? "")
    )

    let maximumLineLength = compactForm.lines.map(\.count).max() ?? 0

    if maximumLineLength <= 100 { return compactForm }

    let indentation = "  "
    let afterOpeningBrace = "\n" + indentation
    let beforeClosingBrace = "\n"

    return arguments.mkString(
      start: title + "(" + afterOpeningBrace,
      format: { "\($0.declaration)" },
      separator: ",\n\(indentation)",
      end: beforeClosingBrace + ")" + (" ".prependTo(returns) ?? "")
    )
  }

  private func initializerBody(storedProperties: [StoredProperty]) -> String {
    storedProperties.mkString(
      format: { "self.\($0.name) = \($0.name)" },
      separator: "\n"
    ) + .newLine + .newLine + "super.init()"
  }
}


extension MobecanDeclaration {

  static func declarationOf(storedProperties: [StoredProperty]) -> String {
    storedProperties.map { "var \($0.name): \($0.type)" }.mkStringWithNewLine()
  }

  static func memberwiseInitializer(storedProperties: [StoredProperty]) -> String {
    initializer(
      arguments: storedProperties.map { $0.asFunctionParameter() },
      body: initializerBody(storedProperties: storedProperties)
    )
  }

  static func memberwiseInitializer(parameters: [FunctionParameter]) -> String {
    initializer(
      arguments: parameters,
      body: initializerBody(storedProperties: parameters.compactMap(\.asStoredProperty))
    )
  }

  static func initializer(arguments: [FunctionParameter],
                          body: String) -> String {
    function(
      keywords: ["public"],
      name: "init",
      arguments: arguments,
      body: body
    )
  }

  static func function(keywords: [String] = ["function"],
                name: String,
                arguments: [FunctionParameter],
                returns: String? = nil,
                body: String) -> String {
    function(
      signature: functionSignature(
        title: (keywords + [name]).mkString(separator: " "),
        arguments: arguments,
        returns: returns
      ),
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

  static func functionSignature(title: String,
                                arguments: [FunctionParameter],
                                returns: String? = nil) -> String {
    let indentation = String(repeating: " ", count: title.count + 1)

    return arguments.mkString(
      start: title + "(",
      format: { "\($0.declaration)" },
      separator: ",\n\(indentation)",
      end: ")" + (" ".prependTo(returns) ?? "")
    )
  }

  private static func initializerBody(storedProperties: [StoredProperty]) -> String {
    storedProperties.mkString(
      format: { "self.\($0.name) = \($0.name)" },
      separator: "\n"
    ) + .newLine + .newLine + "super.init()"
  }
}
