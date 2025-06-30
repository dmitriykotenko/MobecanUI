// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


extension  ArrayDeserializationTests {

  func testNestedNull1() {
    check(
      deserializedType: [Player.Name].self,
      jsonString: """
      [
          {
            "firstName" : null,
            "lastName" : "Чичуев"
          },
          {
            "firstName" : "Дурр",
            "lastName" : "Швамм"
          }
      ]
      """,
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: String.self),
        context: .init(
          codingPath: [
            codingKey(0),
            codingKey("firstName"),
          ],
          debugDescription: unexpectedNullErrorMessage(exectedType: String.self),
          underlyingError: nil
        )
      )
    )
  }

  func testNestedNull2() {
    check(
      deserializedType: [Score].self,
      jsonString: """
      [
        {
          "sets": [
            null,
            {
              "winnerGames" : 6,
              "loserGames" : 0
            }
          ]
        },
        {
          "sets": [
            {
              "winnerGames" : 7,
              "loserGames" : 5
            },
            {
              "winnerGames" : 1,
              "loserGames" : 6
            }
          ]
        },
      ]
      """,
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: [String: Any].self),
        context: .init(
          codingPath: [
            codingKey(0),
            codingKey("sets"),
            codingKey(0)
          ],
          debugDescription: unexpectedNullErrorMessage(exectedType: [String: Any].self),
          underlyingError: nil
        )
      )
    )
  }
}
