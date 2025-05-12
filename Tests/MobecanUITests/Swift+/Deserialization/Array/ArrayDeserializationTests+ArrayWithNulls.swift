// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


extension ArrayDeserializationTests {

  func testArrayWithNulls1() {
    check(
      deserializedType: [Player.Name?].self,
      jsonString: """
      [
        {
          "firstName" : "Чачечич",
          "lastName" : "Чичуев"
        },
        null,
        null,
        {
          "firstName" : "Дурр",
          "lastName" : "Швамм"
        },
        null
      ]
      """,
      expectedResult: .success([
        .init(
          firstName: "Чачечич",
          lastName: "Чичуев"
        ),
        nil,
        nil,
        .init(
          firstName: "Дурр",
          lastName: "Швамм"
        ),
        nil
      ])
    )
  }

  func testArrayWithNulls2() {
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
          "mainHand" : "left",
          "id" : 1
        },
        {
          "name" : {
            "firstName" : "Дурр",
            "lastName" : "Швамм"
          },
          "height" : null,
          "id" : 2,
          "mainHand" : "right"
        },
        null
      ]
      """,
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: [String: Any].self),
        context: .init(
          codingPath: [
            codingKey(2),
          ],
          debugDescription: unexpectedNullErrorMessage(exectedType: [String: Any].self),
          underlyingError: nil
        )
      )
    )
  }
}
