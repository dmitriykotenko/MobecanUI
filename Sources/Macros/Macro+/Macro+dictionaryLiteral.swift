// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension Macro {

  static func dictionaryLiteral(keysAndValues: [(String, String)]) -> String {
    guard keysAndValues.isNotEmpty else { return "[:]" }

    return keysAndValues
      .map { "  " + $0.quoted + ": " + $1 }
      .mkStringWithCommaAndNewLine(start: "[\n", end: "\n]")
  }
}
