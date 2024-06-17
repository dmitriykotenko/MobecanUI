// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


extension  ArrayDeserializationTests {

  func testTopLevelTypeMismatch1() {
    check(
      deserializedType: [Match].self,
      jsonString: """
      ""
      """,
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: [Any].self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Array<Any> but found a string instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testTopLevelTypeMismatch2() {
    check(
      deserializedType: [Match].self,
      jsonString: "{}",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: [Any].self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Array<Any> but found a dictionary instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testNestedTypeMismatch1() {
    check(
      deserializedType: [Match].self,
      jsonString: "[[]]",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: [String: Any].self),
        context: .init(
          codingPath: [
            codingKey(0)
          ],
          debugDescription: "Expected to decode Dictionary<String, Any> but found an array instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testNestedTypeMismatch2() {
    check(
      deserializedType: [Match].self,
      jsonString: """
      [
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
              "id" : "absent",
              "mainHand" : "right"
            }
          ],
          "score" : {
            "sets" : false
          }
        }
      ]
      """,
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Int.self),
        context: .init(
          codingPath: [
            codingKey(0),
            codingKey("players"),
            codingKey(1),
            codingKey("id")
          ],
          debugDescription: "Expected to decode Int but found a string instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testNestedTypeMismatch3() {
    check(
      deserializedType: [Match].self,
      jsonString: """
      [
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
            "realWinner",
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
            "sets" : false
          }
        }
      ]
      """,
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: [String: Any].self),
        context: .init(
          codingPath: [
            codingKey(0),
            codingKey("players"),
            codingKey(1),
          ],
          debugDescription: "Expected to decode Dictionary<String, Any> but found a string instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testNestedTypeMismatch4() {
    check(
      deserializedType: [[[Bool?]]].self,
      jsonString: """
      [
        [],
        [
          [],
          [],
          [],
          [],
          [0, false, true]
        ],
        []
      ]
      """,
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Bool.self),
        context: .init(
          codingPath: [
            codingKey(1),
            codingKey(4),
            codingKey(0),
          ],
          debugDescription: "Expected to decode Bool but found number instead.",
          underlyingError: nil
        )
      )
    )
  }
}
