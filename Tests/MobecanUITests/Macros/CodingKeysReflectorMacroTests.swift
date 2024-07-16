// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI


final class CodingKeysReflectorMacroTests: MacrosTester {

  func testEmptyStructExpansion() {
    checkThat(
      code: """
      @DerivesCodingKeysReflector
      struct EmptyStruct {}
      """,
      expandsTo: """
      struct EmptyStruct {

        static var codingKeyTypes: [String: CodingKeysReflector.Type] {
          [:]
        }
      }

      extension EmptyStruct: SimpleCodingKeysReflector {
      }
      """
    )
  }

  func testEmptyClassExpansion() {
    checkThat(
      code: """
      @DerivesCodingKeysReflector
      class EmptyClass {}
      """,
      expandsTo: """
      class EmptyClass {

        static var codingKeyTypes: [String: CodingKeysReflector.Type] {
          [:]
        }
      }

      extension EmptyClass: SimpleCodingKeysReflector {
      }
      """
    )
  }

  func testStringBasedEnumExpansion() {
    checkThat(
      code: """
      @DerivesCodingKeysReflector
      enum StringBasedEnum: String {
        case someString
        case someOtherString
      }
      """,
      expandsTo: """
      enum StringBasedEnum: String {
        case someString
        case someOtherString
      }

      extension StringBasedEnum: EmptyCodingKeysReflector {
      }
      """
    )
  }

  func testExpansionOfStructWithCodingKeys() {
    checkThat(
      code: """
      @DerivesCodingKeysReflector
      struct StructWithCodingKeys: Codable {

        var _id: String?
        var title: String
        var modificationTimestamp: Int64

        enum CodingKeys: String, CodingKey {
          case _id = "id"
          case title
          case modificationTimestamp = "modified_at"
        }
      }
      """,
      expandsTo: """
      struct StructWithCodingKeys: Codable {

        var _id: String?
        var title: String
        var modificationTimestamp: Int64

        enum CodingKeys: String, CodingKey {
          case _id = "id"
          case title
          case modificationTimestamp = "modified_at"
        }

        static var codingKeyTypes: [String: CodingKeysReflector.Type] {
          [
            "id": String?.self,
            "title": String.self,
            "modified_at": Int64.self
          ]
        }
      }

      extension StructWithCodingKeys: SimpleCodingKeysReflector {
      }
      """
    )
  }

  func testComplexStructExpansion() {
    checkThat(
      code: """
      @DerivesCodingKeysReflector
      struct ComplexStruct {

        @DerivesCodingKeysReflector
        struct EmptyStruct: Codable {

          @DerivesCodingKeysReflector 
          struct NonEmptyStruct: Codable {
            var isNested: Bool
          }
        }

        var bbb: Int
        var ccc: [String]???
        var ddd: Double { 0 }
        var eee: EmptyStruct
      }
      """,
      expandsTo: """
      struct ComplexStruct {
        struct EmptyStruct: Codable {


          struct NonEmptyStruct: Codable {
            var isNested: Bool

            static var codingKeyTypes: [String: CodingKeysReflector.Type] {
              [
                "isNested": Bool.self
              ]
            }
          }

          static var codingKeyTypes: [String: CodingKeysReflector.Type] {
            [:]
          }
        }

        var bbb: Int
        var ccc: [String]???
        var ddd: Double { 0 }
        var eee: EmptyStruct

        static var codingKeyTypes: [String: CodingKeysReflector.Type] {
          [
            "bbb": Int.self,
            "ccc": [String]???.self,
            "eee": EmptyStruct.self
          ]
        }
      }

      extension ComplexStruct.EmptyStruct.NonEmptyStruct: SimpleCodingKeysReflector {
      }

      extension ComplexStruct.EmptyStruct: SimpleCodingKeysReflector {
      }

      extension ComplexStruct: SimpleCodingKeysReflector {
      }
      """
    )
  }

  func testExpansionOfComplexStructWithCodingKeys() {
    checkThat(
      code: """
      @DerivesCodingKeysReflector
      struct ComplexStruct {

        @DerivesCodingKeysReflector
        struct EmptyStruct: Codable {

          @DerivesCodingKeysReflector
          struct NonEmptyStruct: Codable {
            var isNested: Bool

            enum CodingKeys: String, CodingKey {
              case isNested = "is_nested"
            }
          }
        }

        var bbb: Int
        var ccc: [String]???
        var ddd: Double { 0 }
        var eee: EmptyStruct

        enum CodingKeys: String, CodingKey {
          case bbb
          case ccc = "c_c_c"
          case eee = "yep"
        }
      }
      """,
      expandsTo: """
      struct ComplexStruct {
        struct EmptyStruct: Codable {
          struct NonEmptyStruct: Codable {
            var isNested: Bool

            enum CodingKeys: String, CodingKey {
              case isNested = "is_nested"
            }

            static var codingKeyTypes: [String: CodingKeysReflector.Type] {
              [
                "is_nested": Bool.self
              ]
            }
          }

          static var codingKeyTypes: [String: CodingKeysReflector.Type] {
            [:]
          }
        }

        var bbb: Int
        var ccc: [String]???
        var ddd: Double { 0 }
        var eee: EmptyStruct

        enum CodingKeys: String, CodingKey {
          case bbb
          case ccc = "c_c_c"
          case eee = "yep"
        }

        static var codingKeyTypes: [String: CodingKeysReflector.Type] {
          [
            "bbb": Int.self,
            "c_c_c": [String]???.self,
            "yep": EmptyStruct.self
          ]
        }
      }

      extension ComplexStruct.EmptyStruct.NonEmptyStruct: SimpleCodingKeysReflector {
      }

      extension ComplexStruct.EmptyStruct: SimpleCodingKeysReflector {
      }

      extension ComplexStruct: SimpleCodingKeysReflector {
      }
      """
    )
  }
}
