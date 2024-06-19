// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI


/// Специальный класс для проверки, что результат применения макросов всегда компилируется.
///
/// Если при компиляции тестового таргета в этом классе возникли ошибки,
/// значит, макросы сгенерировали некомпилируемый код.
class MacroExpansionCompileErrorsCatcher {

  @CodingKeysReflection
  struct ComplexStruct {

    @CodingKeysReflection
    struct EmptyStruct: Codable {

      @CodingKeysReflection
      struct NonEmptyStruct: Codable {
        
        var isNested: Bool
        var nestedValue: AnotherEmptyStruct
        var yetAnotherNestedValue: YetAnotherEmptyStructWithCustomCodingKeys
      }

      @CodingKeysReflection
      struct AnotherEmptyStruct: Codable {}

      @CodingKeysReflection
      struct YetAnotherEmptyStructWithCustomCodingKeys: Codable {

        var string: String
        var intNumber: Int?

        enum CodingKeys: String, CodingKey {
          case string
          case intNumber = "int_number"
        }
      }
    }

    var bbb: Int
    var ccc: [String]???
    var ddd: Double { 0 }
    var eee: EmptyStruct
  }
}
