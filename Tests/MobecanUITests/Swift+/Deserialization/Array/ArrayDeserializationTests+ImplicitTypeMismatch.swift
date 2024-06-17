// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


extension  ArrayDeserializationTests {

  func testImplicitTypeMismatch1() {
    check(
      deserializedType: [Int].self,
      jsonString: "[1, 2, 88888.8888]",
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [],
          debugDescription: "The given data was not valid JSON.",
          underlyingError:
            NSError(
              domain: "NSCocoaErrorDomain",
              code: 3840,
              userInfo: [
                "NSDebugDescription": "Number 88888.8888 is not representable in Swift."
              ]
            )
            .stableDescription
        )
      )
    )
  }

  func testImplicitTypeMismatch2() {
    check(
      deserializedType: [Decimal].self,
      jsonString: """
      [
        1,
        2,
        "88888888888888888888888888888888888888888888888888888888888888888888"
      ]
      """,
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Decimal.self),
        context: .init(
          codingPath: [
            codingKey(2),
          ],
          debugDescription: "",
          underlyingError: nil
        )
      )
    )
  }

  func testImplicitTypeMismatch3() {
    check(
      deserializedType: [GoodNumbersEnum].self,
      jsonString: """
      [
        -2,
        665
      ]
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [
            codingKey(1),
          ],
          debugDescription: "Cannot initialize GoodNumbersEnum from invalid Int value 665"
        )
      )
    )
  }

  func testImplicitTypeMismatch4() {
    check(
      deserializedType: [CityEnum].self,
      jsonString: """
      [
        "melbourne",
        "pretoria",
        "buenosAires",
        "london"
      ]
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [
            codingKey(3),
          ],
          debugDescription: "Cannot initialize CityEnum from invalid String value london"
        )
      )
    )
  }

  func testImplicitTypeMismatch5() {
    check(
      deserializedType: [Player].self,
      jsonString: """
      [
        {
          "name" : {
            "firstName" : "Чачечич",
            "lastName" : "Чичуев"
          },
          "height" : 1.99,
          "mainHand" : "foreHand",
          "id" : 1
        }
      ]
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [
            codingKey(0),
            codingKey("mainHand"),
          ],
          debugDescription: "Cannot initialize Hand from invalid String value foreHand"
        )
      )
    )
  }

  func testImplicitTypeMismatch6() {
    check(
      deserializedType: [URL].self,
      jsonString: """
      [
        "( - : - )"
      ]
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [
            codingKey(0)
          ],
          debugDescription: "Invalid URL string."
        )
      )
    )
  }

  func testImplicitTypeMismatch7() {
    check(
      deserializedType: [Data].self,
      jsonString: """
      [
        "I'm a «🕵🏻‍♂️» and a „🦄“ из 🇪🇨"
      ]
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [codingKey(0)],
          debugDescription: "Encountered Data is not valid Base64.",
          underlyingError: nil
        )
      )
    )
  }

  func testImplicitTypeMismatch8() {
    check(
      deserializedType: [DataContainer].self,
      jsonString: """
      [
        {
          "someData": "333"
        }
      ]
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [
            codingKey(0),
            codingKey("someData")
          ],
          debugDescription: "Encountered Data is not valid Base64."
        )
      )
    )
  }
}
