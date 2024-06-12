import XCTest

import SnapKit
import RxSwift
import SwiftDateTime

@testable import MobecanUI


final class TypeNameTests_CustomClassesAndStructs: TypeNameTester {

  func testSelf() {
    check(
      type: Self.self,
      expectedTypeName: .init(
        nonQualified: "TypeNameTests_CustomClassesAndStructs",
        qualified: "MobecanUITests.TypeNameTests_CustomClassesAndStructs",
        mangled: areMangledNamesSupported ? "14MobecanUITests37TypeNameTests_CustomClassesAndStructsC" : nil
      )
    )

    check(
      type: Self.self,
      shouldBeReconstructed: true
    )
  }

  func testJsonValue() {
    check(
      type: JsonValue.self,
      expectedTypeName: .init(
        nonQualified: "JsonValue",
        qualified: "MobecanUI.JsonValue",
        mangled: areMangledNamesSupported ? "9MobecanUI9JsonValueO" : nil
      )
    )

    check(
      type: JsonValue.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testGenericClass() {
    check(
      type: ContainingClass<String>.self,
      expectedTypeName: .init(
        nonQualified: "ContainingClass<String>",
        qualified: "MobecanUITests.TypeNameTester.ContainingClass<Swift.String>",
        mangled: areMangledNamesSupported ? "14MobecanUITests14TypeNameTesterC15ContainingClassCy_SSG" : nil
      )
    )

    check(
      type: ContainingClass<String>.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testNestedClass() {
  }

  func testExternalGenericClass() {
    check(
      type: ContainingClassForTypeNameTests<String>.self,
      expectedTypeName: .init(
        nonQualified: "ContainingClassForTypeNameTests<String>",
        qualified: "MobecanUITests.ContainingClassForTypeNameTests<Swift.String>",
        mangled: areMangledNamesSupported ? "14MobecanUITests31ContainingClassForTypeNameTestsCySSG" : nil
      )
    )

    check(
      type: ContainingClassForTypeNameTests<String>.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testExternalNestedClass() {
    check(
      type: ContainingClassForTypeNameTests<SomeEnumForTypeNameTests>.NestedClass.self,
      expectedTypeName: .init(
        nonQualified:
          "NestedClass",
        qualified:
          "MobecanUITests.ContainingClassForTypeNameTests<MobecanUITests.SomeEnumForTypeNameTests>.NestedClass",
        mangled:
          areMangledNamesSupported ?
            "14MobecanUITests31ContainingClassForTypeNameTestsC06NestedD0CyAA08SomeEnumefgH0O_G" :
            nil
      )
    )

    check(
      type: ContainingClassForTypeNameTests<SomeEnumForTypeNameTests>.NestedClass.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testPrivateGenericClass() {
    check(
      type: PrivateContainingClass<String>.self,
      expectedNonQualifiedName: "PrivateContainingClass<String>"
    )

    check(
      type: PrivateContainingClass<String>.self,
      shouldBeReconstructed: false
    )
  }

  func testPrivateNestedClass() {
    check(
      type: PrivateContainingClass<SomePrivateEnum>.NestedClass.self,
      expectedNonQualifiedName: "NestedClass"
    )

    check(
      type: PrivateContainingClass<SomePrivateEnum>.NestedClass.self,
      shouldBeReconstructed: false
    )
  }
}


private enum SomePrivateEnum { case someEnumCase }


private class PrivateContainingClass<Value> {

  var nestedClass: NestedClass?

  class NestedClass {
    var value: Value?
  }
}
