// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


extension CustomTypeDeserializationTests {

  func testAbsentKey1() {
    check(
      deserializedType: Match.self,
      jsonString: """
      {
        "players" : [
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
          }
        ],
        "score" : {}
      }
      """,
      expectedDecodingError: .keyNotFound(
        codingKey: 
            codingKey("sets"),
        context: .init(
          codingPath: [
            codingKey("score")
          ],
          debugDescription: """
          No value associated with key CodingKeys(stringValue: \"sets\", intValue: nil) (\"sets\").
          """,
          underlyingError: nil
        )
      )
    )
  }

  func testAbsentKey2() {
    check(
      deserializedType: Match.self,
      jsonString: """
      {
        "players" : [
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
          }
        ],
        "score" : {
          "sets": [
            {
              "winnerGames" : 6,
              "loserGames" : 0
            },
            {
              "winnerGames" : 7,
              "loserGames" : 5
            },
            {
              "loserGames" : 6
            }
          ]
        }
      }
      """,
      expectedDecodingError: .keyNotFound(
        codingKey:
            codingKey("winnerGames"),
        context: .init(
          codingPath: [
            codingKey("score"),
            codingKey("sets"),
            codingKey(2)
          ],
          debugDescription: """
          No value associated with key CodingKeys(stringValue: \"winnerGames\", intValue: nil) (\"winnerGames\").
          """,
          underlyingError: nil
        )
      )
    )
  }

  func testAbsentKey3() {
    check(
      deserializedType: Match.self,
      jsonString: """
      {
        "players" : [
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
          }
        ]
      }
      """,
      expectedDecodingError: .keyNotFound(
        codingKey:
            codingKey("score"),
        context: .init(
          codingPath: [],
          debugDescription: """
          No value associated with key CodingKeys(stringValue: \"score\", intValue: nil) (\"score\").
          """,
          underlyingError: nil
        )
      )
    )
  }
}
