// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

import Foundation


enum UrlMacroError: Error, CustomStringConvertible {

  case argumentMustBeStaticStringLiteral
  case invalidUrl(urlString: String)

  var description: String {
    switch self {
    case .argumentMustBeStaticStringLiteral:
      "#URL() requires a static string literal"
    case .invalidUrl(let urlString):
      "\"\(urlString)\" is invalid or unsupported URL"
    }
  }
}
