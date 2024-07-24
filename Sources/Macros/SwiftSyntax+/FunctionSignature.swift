// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct FunctionSignature {

  var keywords: [String] = ["func"]
  var name: String
  var genericParameters: [String] = []
  var parameters: [FunctionParameter]
  var beforeReturns: [String] = []
  var returns: String? = nil
  var `where`: String? = nil

  var isThrowing: Bool { beforeReturns.contains("throws") }

  func build(isCompact: Bool,
             lineLengthThreshold: Int = 100) -> String {
    let compactForm = buildCompactly()

    let maximumLineLength = compactForm.lines.map(\.count).max() ?? 0

    if isCompact && maximumLineLength <= lineLengthThreshold {
      return compactForm
    } else {
      return buildMaximallyPrettyPrinted()
    }
  }

  private func buildCompactly() -> String {
    let titleString = buildTitle(isCompact: true)

    return build(
      titleString: titleString,
      indentation: String(repeating: " ", count: titleString.count + 1),
      afterOpeningBrace: "",
      beforeClosingBrace: ""
    )
  }

  private func buildMaximallyPrettyPrinted() -> String {
    build(
      titleString: buildTitle(isCompact: false),
      indentation: "  ",
      afterOpeningBrace: .newLine + "  ",
      beforeClosingBrace: .newLine
    )
  }

  private func build(titleString: String,
                     indentation: String,
                     afterOpeningBrace: String,
                     beforeClosingBrace: String) -> String {
    parameters.mkString(
      start: titleString + "(" + afterOpeningBrace,
      format: { "\($0.declaration)" },
      separator: ",\n\(indentation)",
      end: beforeClosingBrace + ")" + returnsAndWhere()
    )
  }

  private func buildTitle(isCompact: Bool) -> String {
    switch genericParameters.count {
    case 0:
      return keywords.mkStringWithSpace() + " " + name
    default:
      return keywords.mkStringWithSpace() + " " + name + withAngleBrackets(
        genericParameters: genericParameters,
        isCompact: isCompact
      )
    }
  }

  private func withAngleBrackets(genericParameters: [String] = [],
                                 isCompact: Bool) -> String {
    isCompact ?
      genericParameters.mkStringWithComma() :
      [
        "<",
        "  ".prependingToLines(of: genericParameters.mkStringWithCommaAndNewLine()),
        ">"
      ]
      .mkStringWithNewLine()
  }

  private func returnsAndWhere() -> String {
    (" ".prependTo(beforeReturns.mkStringWithSpace().notBlankOrNil) ?? "")
    + (" ".prependTo(returns) ?? "")
    + (.newLine.prependTo(`where`) ?? "")
  }
}
