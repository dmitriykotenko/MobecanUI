// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


extension CustomTypeDeserializationTests {

  func testValidMatch1() {
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
            "height" : 2.99,
            "id" : 2,
            "mainHand" : "right"
          }
        ],
        "winner" : {
          "id" : 1,
          "name" : {
            "firstName" : "Чачечич",
            "lastName" : "Чичуев"
          },
          "mainHand" : "left"
        },
        "score" : {
          "sets" : [
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
              "winnerGames" : 6,
              "loserGames" : 2
            }
          ]
        }
      }
      """,
      expectedResult: .success(.init(
        players: [
          Player(
            id: 1,
            height: 1.99,
            name: .init(firstName: "Чачечич", lastName: "Чичуев"),
            mainHand: .left
          ),
          Player(
            id: 2,
            height: 2.99,
            name: .init(firstName: "Дурр", lastName: "Швамм"),
            mainHand: .right
          )
        ],
        winner: Player(
          id: 1,
          name: .init(firstName: "Чачечич", lastName: "Чичуев"),
          mainHand: .left
        ),
        score: .init(sets: [
          .init(winnerGames: 6, loserGames: 0),
          .init(winnerGames: 7, loserGames: 5),
          .init(winnerGames: 1, loserGames: 6),
          .init(winnerGames: 6, loserGames: 2)
        ])
      ))
    )
  }

  func testValidMatch2() {
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
        "winner" : null,
        "score" : {
          "sets" : [
            {
              "winnerGames" : 6,
              "loserGames" : 0
            },
            {
              "winnerGames" : 7,
              "loserGames" : 5
            }
          ]
        }
      }
      """,
      expectedResult: .success(.init(
        players: [
          Player(
            id: 1,
            height: 1.99,
            name: .init(firstName: "Чачечич", lastName: "Чичуев"),
            mainHand: .left
          ),
          Player(
            id: 2,
            name: .init(firstName: "Дурр", lastName: "Швамм"),
            mainHand: .right
          )
        ],
        score: .init(sets: [
          .init(winnerGames: 6, loserGames: 0),
          .init(winnerGames: 7, loserGames: 5)
        ])
      ))
    )
  }

  func testValidMatch3() {
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
          "sets" : []
        }
      }
      """,
      expectedResult: .success(.init(
        players: [
          Player(
            id: 1,
            height: 1.99,
            name: .init(firstName: "Чачечич", lastName: "Чичуев"),
            mainHand: .left
          ),
          Player(
            id: 2,
            name: .init(firstName: "Дурр", lastName: "Швамм"),
            mainHand: .right
          )
        ],
        score: .init(sets: [])
      ))
    )
  }

  func testDeserializationOfOptionalMatch() {
    check(
      deserializedType: Match?.self,
      jsonString: "null",
      expectedResult: .success(nil)
    )
  }

}
