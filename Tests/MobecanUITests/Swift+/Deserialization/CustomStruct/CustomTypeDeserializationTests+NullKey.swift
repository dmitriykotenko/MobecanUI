// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


extension CustomTypeDeserializationTests {

  func testNullKey1() {
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
        "score": null
      }
      """,
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: [String: Any].self),
        context: .init(
          codingPath: [
            codingKey("score")
          ],
          debugDescription: "Cannot get keyed decoding container -- found null value instead",
          underlyingError: nil
        )
      )
    )
  }

  func testNullKey2() {
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
        "score": {
          "sets": null
        }
      }
      """,
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: [Any].self),
        context: .init(
          codingPath: [
            codingKey("score"),
            codingKey("sets")
          ],
          debugDescription: "Cannot get unkeyed decoding container -- found null value instead",
          underlyingError: nil
        )
      )
    )
  }

  func testNullKey3() {
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
            null,
            {
              "winnerGames" : 1,
              "loserGames" : 6
            }
          ]
        }
      }
      """,
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: [String: Any].self),
        context: .init(
          codingPath: [
            codingKey("score"),
            codingKey("sets"),
            codingKey(2)
          ],
          debugDescription: "Cannot get keyed decoding container -- found null value instead",
          underlyingError: nil
        )
      )
    )
  }

  func testNullKey4() {
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
              "winnerGames" : null,
              "loserGames" : 6
            }
          ]
        }
      }
      """,
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: Int.self),
        context: .init(
          codingPath: [
            codingKey("score"),
            codingKey("sets"),
            codingKey(2),
            codingKey("winnerGames")
          ],
          debugDescription: "Cannot get unkeyed decoding container -- found null value instead",
          underlyingError: nil
        )
      )
    )
  }

  func testNullKey5() {
    check(
      deserializedType: WebSite.self,
      jsonString: """
      {
        "homePage": null
      }
      """,
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: URL.self),
        context: .init(
          codingPath: [codingKey("homePage")],
          debugDescription: "Cannot get unkeyed decoding container -- found null value instead",
          underlyingError: nil
        )
      )
    )
  }
}
