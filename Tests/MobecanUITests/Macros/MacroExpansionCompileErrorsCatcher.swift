// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import NonEmpty
import RxSwift
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport

import MobecanUI


/// Специальный класс для проверки, что результат применения макросов всегда компилируется.
///
/// Если при компиляции тестового таргета в этом классе возникли ошибки,
/// значит, макросы сгенерировали некомпилируемый код.
class MacroExpansionCompileErrorsCatcher {

  @TryInit
  public enum Banknotes {
    case nothing
    case roubles(Int)
    case euros(amount: Int, fakeness: Double)
    case pounds(Int, royalness: Double = 999)

    init(euros: Int) {
      self = .euros(amount: euros, fakeness: 1)
    }
  }

  @TryInit
  open class Pair<First, Second> {
    var first: First?
    var second: Second

    init!(_: Bool = false,
         _ first: First? = nil,
         second: Second) {
      self.first = first
      self.second = second
    }

    public required init?(firstAndSecond: (First?, Second)) throws {
      self.first = firstAndSecond.0
      self.second = firstAndSecond.1
    }

    init<Element: Hashable>(elements: Set<Element>) where Second == [Element] {
      self.first = nil
      self.second = elements.asArray
    }
  }

  @DerivesAutoGeneratable
  @DerivesCodingKeysReflector
  struct GeneratableStruct {
    var aaa: String
    var bbb: Int
  }

  @DerivesAutoGeneratable
  struct GeneratableEmptyStruct {}

  @DerivesAutoGeneratable
  enum GeneratablishEnum {
    case aaa
    case bbb(String)
    case ccc(ccc: String)
    case ddd(Int, Int, final: String)
  }

  @DerivesAutoGeneratable
  enum GenericEnum<BBB, DDD> {
    case aaa
    case bbb(BBB)
    case ccc(ccc: String)
    case ddd(DDD, Int, final: DDD)
  }


  @DerivesAutoGeneratable
  enum Subject<Animal, Human> {
    case legalPerson
    case animal(Animal)
    case human(Human, age: Int)
  }

  @DerivesCodingKeysReflector
  struct ComplexStruct {

    @DerivesCodingKeysReflector
    struct EmptyStruct: Codable {

      @DerivesCodingKeysReflector
      struct NonEmptyStruct: Codable {
        
        var isNested: Bool
        var nestedValue: AnotherEmptyStruct
        var yetAnotherNestedValue: YetAnotherEmptyStructWithCustomCodingKeys
      }

      @DerivesCodingKeysReflector
      struct AnotherEmptyStruct: Codable {}

      @DerivesCodingKeysReflector
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

    static let url3 = #URL("https://www.apple.com")

    static let vvv: Result<Banknotes, SomeError> = Banknotes.tryInit.euros(
      amount: .success(0),
      fakeness: .success(5)
    )
  }
}


import NonEmpty
struct SomeError: ComposableError {
  static func composed(from children: NonEmpty<[String : SomeError]>) -> SomeError {
    fatalError()
  }
}
