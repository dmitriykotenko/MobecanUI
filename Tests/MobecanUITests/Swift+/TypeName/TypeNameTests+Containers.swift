import XCTest

import SnapKit
import RxSwift
import SwiftDateTime

@testable import MobecanUI


final class TypeNameTests_Containers: TypeNameTester {

  func testOptional() {
    check(
      type: String?.self,
      expectedTypeName: .init(
        nonQualified: "Optional<String>",
        qualified: "Swift.Optional<Swift.String>",
        mangled: areMangledNamesSupported ? "SSSg" : nil
      )
    )

    check(
      type: String?.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testDoubleOptional() {
    check(
      type: String??.self,
      expectedTypeName: .init(
        nonQualified: "Optional<Optional<String>>",
        qualified: "Swift.Optional<Swift.Optional<Swift.String>>",
        mangled: areMangledNamesSupported ? "SSSgSg" : nil
      )
    )

    check(
      type: String??.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testResult() {
    check(
      type: Result<Int, SwiftDateTime.ParseError>.self,
      expectedTypeName: .init(
        nonQualified: "Result<Int, ParseError>",
        qualified: "Swift.Result<Swift.Int, SwiftDateTime.ParseError>",
        mangled: areMangledNamesSupported ? "s6ResultOySi13SwiftDateTime10ParseErrorOG" : nil
      )
    )

    check(
      type: Result<Int, SwiftDateTime.ParseError>.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testArrayOfStrings() {
    check(
      type: [String].self,
      expectedTypeName: .init(
        nonQualified: "Array<String>",
        qualified: "Swift.Array<Swift.String>",
        mangled: areMangledNamesSupported ? "SaySSG" : nil
      )
    )

    check(
      type: [String].self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testArrayArrayOfInts() {
    check(
      type: [[Int]].self,
      expectedTypeName: .init(
        nonQualified: "Array<Array<Int>>",
        qualified: "Swift.Array<Swift.Array<Swift.Int>>",
        mangled: areMangledNamesSupported ? "SaySaySiGG" : nil
      )
    )

    check(
      type: [[Int]].self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testDictionary1() {
    check(
      type: [Int: String].self,
      expectedTypeName: .init(
        nonQualified: "Dictionary<Int, String>",
        qualified: "Swift.Dictionary<Swift.Int, Swift.String>",
        mangled: areMangledNamesSupported ? "SDySiSSG" : nil
      )
    )

    check(
      type: [Int: String].self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testDictionary2() {
    check(
      type: [URL: [URL]].self,
      expectedTypeName: .init(
        nonQualified: "Dictionary<URL, Array<URL>>",
        qualified: "Swift.Dictionary<Foundation.URL, Swift.Array<Foundation.URL>>",
        mangled: areMangledNamesSupported ? "SDy10Foundation3URLVSayACGG" : nil
      )
    )

    check(
      type: [URL: [URL]].self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testArrayOfDictionaries() {
    check(
      type: [[Int: String]].self,
      expectedTypeName: .init(
        nonQualified: "Array<Dictionary<Int, String>>",
        qualified: "Swift.Array<Swift.Dictionary<Swift.Int, Swift.String>>",
        mangled: areMangledNamesSupported ? "SaySDySiSSGG" : nil
      )
    )

    check(
      type: [[Int: String]].self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }
}
