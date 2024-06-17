// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


extension CustomTypeDeserializationTests {

  func testNestedUnrepresentableInt() {
    check(
      deserializedType: Score.SetScore.self,
      jsonString: """
      {
        "winnerGames": 6,
        "loserGames": 6.75
      }
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [],
          debugDescription: "The given data was not valid JSON.",
          underlyingError:
            NSError(
              domain: "NSCocoaErrorDomain",
              code: 3840,
              userInfo: ["NSDebugDescription": "Number 6.75 is not representable in Swift."]
            )
            .stableDescription
        )
      )
    )
  }

  func testNestedUnrepresentableDouble() {
    check(
      deserializedType: Player.self,
      jsonString: """
      {
        "id": 6,
        "height": 99.99e+99999,
        "mainHand": "left",
        "name": {
          "firstName": "Дурр",
          "lastName": "Швамм"
        }
      }
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [],
          debugDescription: "The given data was not valid JSON.",
          underlyingError:
            NSError(
              domain: "NSCocoaErrorDomain",
              code: 3840,
              userInfo: ["NSDebugDescription": "Number 99.99e+99999 is not representable in Swift."]
            )
            .stableDescription
        )
      )
    )
  }

  func testNestedUnknownIntEnumCase() {
    check(
      deserializedType: NumbersPhile.self,
      jsonString: """
      {
        "favoriteNumber": 1
      }
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [
            codingKey("favoriteNumber")
          ],
          debugDescription: "Cannot initialize GoodNumbersEnum from invalid Int value 1",
          underlyingError: nil
        )
      )
    )
  }

  func testNestedUnknownStringEnumCase() {
    check(
      deserializedType: Country.self,
      jsonString: """
      {
        "name": "england",
        "capital": "london"
      }
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [
            codingKey("capital")
          ],
          debugDescription: "Cannot initialize CityEnum from invalid String value london",
          underlyingError: nil
        )
      )
    )
  }

  func testNestedInvalidUrl() {
    check(
      deserializedType: WebSite.self,
      jsonString: """
      {
        "homePage": "Welcome to hell :-)"
      }
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [codingKey("homePage")],
          debugDescription: "Invalid URL string.",
          underlyingError: nil
        )
      )
    )
  }

  func testNestedInvalidData1() {
    check(
      deserializedType: DataContainer.self,
      jsonString: """
      {
        "someData": "I'm a «🕵🏻‍♂️» and a „🦄“ из 🇪🇨"
      }
      """,
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [codingKey("someData")],
          debugDescription: "Encountered Data is not valid Base64.",
          underlyingError: nil
        )
      )
    )
  }
}
