import XCTest

import SnapKit
import RxSwift
import SwiftDateTime

@testable import MobecanUI


class TypeNameTester: XCTestCase {

  enum SomeEnum { case someEnumCase }

  class ContainingClass<Value> {

    var nestedClass: NestedClass?

    class NestedClass {
      var value: Value?
    }
  }

  let iOSversion = UIDevice.current.systemVersion
  lazy var areMangledNamesSupported = iOSversion >= "14"

  func check(type originalType: Any.Type,
             expectedTypeName: TypeName,
             file: StaticString = #file,
             line: UInt = #line) {
    let actualTypeName = TypeName(type: originalType)

    XCTAssertEqual(
      actualTypeName.nonQualified, expectedTypeName.nonQualified,
      "Короткое название не совпадает",
      file: file,
      line: line
    )

    XCTAssertEqual(
      actualTypeName.qualified, expectedTypeName.qualified,
      "Полное название не совпадает",
      file: file,
      line: line
    )

    if areMangledNamesSupported {
      XCTAssertEqual(
        actualTypeName.mangled, expectedTypeName.mangled,
        "Mangled-название не совпадает",
        file: file,
        line: line
      )
    }
  }

  func check(type originalType: Any.Type,
             expectedNonQualifiedName: String,
             file: StaticString = #file,
             line: UInt = #line) {
    let actualTypeName = TypeName(type: originalType)

    XCTAssertEqual(
      actualTypeName.nonQualified, expectedNonQualifiedName,
      "Короткое название не совпадает",
      file: file,
      line: line
    )
  }

  func check(type originalType: Any.Type,
             shouldBeReconstructed: Bool,
             file: StaticString = #file,
             line: UInt = #line) {
    let typeName = TypeName(type: originalType)

    if shouldBeReconstructed {
      XCTAssert(
        typeName.reconstructedType == originalType,
        "Не удалось воссоздать тип \(typeName)",
        file: file,
        line: line
      )
    } else {
      XCTAssert(
        typeName.reconstructedType == nil,
        "Почему-то вдруг удалось воссоздать тип \(typeName)",
        file: file,
        line: line
      )
    }
  }
}


enum SomeEnumForTypeNameTests { case someEnumCase }


class ContainingClassForTypeNameTests<Value> {

  var nestedClass: NestedClass?

  class NestedClass {
    var value: Value?
  }
}
