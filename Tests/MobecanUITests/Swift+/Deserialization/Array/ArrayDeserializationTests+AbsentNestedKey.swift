// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


extension  ArrayDeserializationTests {

  func testAbsentNestedKey1() {
    check(
      deserializedType: [Player].self,
      jsonString: """
      [
        {
          "name" : {
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
        }
      ]
      """,
      expectedDecodingError: .keyNotFound(
        codingKey:
            codingKey("firstName"),
        context: .init(
          codingPath: [
            codingKey(0),
            codingKey("name")
          ],
          debugDescription: """
          No value associated with key CodingKeys(stringValue: \"firstName\", intValue: nil) (\"firstName\").
          """,
          underlyingError: nil
        )
      )
    )
  }

  func testAbsentNestedKey2() {
    check(
      deserializedType: [[Score.SetScore]].self,
      jsonString: """
      [
        [
          {
            "winnerGames" : 6,
            "loserGames" : 0
          },
          {
            "winnerGames" : 7,
            "loserGames" : 5
          },
          {
            "winnerGames" : 1,
            "loserGames" : 6
          },
          {
            "loserGames" : 2
          }
        ]
      ]
      """,
      expectedDecodingError: .keyNotFound(
        codingKey:
            codingKey("winnerGames"),
        context: .init(
          codingPath: [
            codingKey(0),
            codingKey(3)
          ],
          debugDescription: """
          No value associated with key CodingKeys(stringValue: \"winnerGames\", intValue: nil) (\"winnerGames\").
          """,
          underlyingError: nil
        )
      )
    )
  }
}
