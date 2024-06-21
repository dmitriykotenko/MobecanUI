// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

import Foundation


/// Проверяет во время компиляции, что переданная строка является валидным урлом.
public struct UrlMacro: ExpressionMacro {

  public static func expansion(of node: some FreestandingMacroExpansionSyntax,
                               in context: some MacroExpansionContext) throws -> ExprSyntax {
    guard
      let argument = node.arguments.first,
      let stringLiteral = argument.expression.as(StringLiteralExprSyntax.self),
      let staticString = stringLiteral.asStaticString
      else { throw UrlMacroError.argumentMustBeStaticStringLiteral }

    if URL(string: staticString) == nil {
      throw UrlMacroError.invalidUrl(urlString: "\(staticString)")
    }

    return "URL(string: \(argument))!"
  }
}


extension StringLiteralExprSyntax {

  var asStaticString: String? {
    switch (segments.count, segments.first) {
    case (1, .stringSegment(let staticString)):
      return staticString.content.text
    default:
      return nil
    }
  }
}
