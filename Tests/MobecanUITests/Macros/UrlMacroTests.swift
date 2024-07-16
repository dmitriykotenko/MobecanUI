// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI


final class UrlMacroTests: MacrosTester {

  func testValidUrls() {
    checkThat(
      code: """
      _ = #URL("about:blank")
      _ = #URL("0.0.0.0")
      _ = #URL("https://www.google.com")
      _ = #URL("https://www.google.com?someQuery=a&somePseudoCookie=[]")
      """,
      expandsTo: """
      _ = URL(string: "about:blank")!
      _ = URL(string: "0.0.0.0")!
      _ = URL(string: "https://www.google.com")!
      _ = URL(string: "https://www.google.com?someQuery=a&somePseudoCookie=[]")!
      """
    )
  }

  func testNonStaticString() {
    checkThat(
      code: """
      #URL("about:" + "blank")
      """,
      expandsTo: """
      #URL("about:" + "blank")
      """,
      withDiagnostics: [
        .init(
          message: "#URL() requires a static string literal",
          line: 1,
          column: 1
        )
      ]
    )
  }

  func testInvalidUrl() {
    checkThat(
      code: """

      _ = #URL("( - : - )")

      """,
      expandsTo: """

      _ = #URL("( - : - )")

      """,
      withDiagnostics: [
        .init(
          message: """
          "( - : - )" is invalid or unsupported URL
          """,
          line: 2,
          column: 5
        )
      ]

    )
  }
}
