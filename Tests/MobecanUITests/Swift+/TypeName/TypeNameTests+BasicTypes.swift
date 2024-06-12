import XCTest

import SnapKit
import RxSwift
import SwiftDateTime

@testable import MobecanUI


final class TypeNameTests_BasicTypes: TypeNameTester {

  func testNever() {
    check(
      type: Never.self,
      expectedTypeName: .init(
        nonQualified: "Never",
        qualified: "Swift.Never",
        mangled: areMangledNamesSupported ? "s5NeverO" : nil
      )
    )

    check(
      type: Never.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testVoid() {
    check(
      type: Void.self,
      expectedTypeName: .init(
        nonQualified: "()",
        qualified: "()",
        mangled: areMangledNamesSupported ? "yt" : nil
      )
    )

    check(
      type: Void.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testAny() {
    check(
      type: Any.self,
      expectedTypeName: .init(
        nonQualified: "Any",
        qualified: "Any",
        mangled: areMangledNamesSupported ? "yp" : nil
      )
    )

    check(
      type: Any.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testAnyObject() {
    check(
      type: AnyObject.self,
      expectedTypeName: .init(
        nonQualified: "AnyObject",
        qualified: "Swift.AnyObject",
        mangled: areMangledNamesSupported ? "yXl" : nil
      )
    )

    check(
      type: AnyObject.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testBool() {
    check(
      type: Bool.self,
      expectedTypeName: .init(
        nonQualified: "Bool",
        qualified: "Swift.Bool",
        mangled: areMangledNamesSupported ? "Sb" : nil
      )
    )

    check(
      type: Bool.self,
      shouldBeReconstructed: true
    )
  }

  func testInt() {
    check(
      type: Int.self,
      expectedTypeName: .init(
        nonQualified: "Int",
        qualified: "Swift.Int",
        mangled: areMangledNamesSupported ? "Si" : nil
      )
    )

    check(
      type: Int.self,
      shouldBeReconstructed: true
    )
  }

  func testInt64() {
    check(
      type: Int64.self,
      expectedTypeName: .init(
        nonQualified: "Int64",
        qualified: "Swift.Int64",
        mangled: areMangledNamesSupported ? "s5Int64V" : nil
      )
    )

    check(
      type: Int64.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testFloat() {
    check(
      type: Float.self,
      expectedTypeName: .init(
        nonQualified: "Float",
        qualified: "Swift.Float",
        mangled: areMangledNamesSupported ? "Sf" : nil
      )
    )

    check(
      type: Float.self,
      shouldBeReconstructed: true
    )
  }

  func testDouble() {
    check(
      type: Double.self,
      expectedTypeName: .init(
        nonQualified: "Double",
        qualified: "Swift.Double",
        mangled: areMangledNamesSupported ? "Sd" : nil
      )
    )

    check(
      type: Double.self,
      shouldBeReconstructed: true
    )
  }

  func testDecimal() {
    check(
      type: Decimal.self,
      expectedTypeName: .init(
        nonQualified: "NSDecimal",
        qualified: "__C.NSDecimal",
        mangled: areMangledNamesSupported ? "So9NSDecimala" : nil
      )
    )

    check(
      type: Decimal.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testNumber() {
    check(
      type: NSNumber.self,
      expectedTypeName: .init(
        nonQualified: "NSNumber",
        qualified: "NSNumber",
        mangled: areMangledNamesSupported ? "So8NSNumberC" : nil
      )
    )

    check(
      type: NSNumber.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testString() {
    check(
      type: String.self,
      expectedTypeName: .init(
        nonQualified: "String",
        qualified: "Swift.String",
        mangled: areMangledNamesSupported ? "SS" : nil
      )
    )

    check(
      type: String.self,
      shouldBeReconstructed: true
    )
  }

  func testData() {
    check(
      type: Data.self,
      expectedTypeName: .init(
        nonQualified: "Data",
        qualified: "Foundation.Data",
        mangled: areMangledNamesSupported ? "10Foundation4DataV" : nil
      )
    )

    check(
      type: Data.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testDate() {
    check(
      type: Date.self,
      expectedTypeName: .init(
        nonQualified: "Date",
        qualified: "Foundation.Date",
        mangled: areMangledNamesSupported ? "10Foundation4DateV" : nil
      )
    )

    check(
      type: Date.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testURL() {
    check(
      type: URL.self,
      expectedTypeName: .init(
        nonQualified: "URL",
        qualified: "Foundation.URL",
        mangled: areMangledNamesSupported ? "10Foundation3URLV" : nil
      )
    )

    check(
      type: URL.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }
}
