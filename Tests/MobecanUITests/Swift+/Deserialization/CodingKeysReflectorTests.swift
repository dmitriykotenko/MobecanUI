// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


class CodingKeysReflectorTests: DeserializationTester {

  func testEmptyPath() {
    checkThat(
      Match.self,
      hasTypes: [Match.self],
      forPath: []
    )

    checkThat(
      String.self,
      hasTypes: [String.self],
      forPath: []
    )

    checkThat(
      Bool?.self,
      hasTypes: [Bool?.self],
      forPath: []
    )
  }

  func testSingularPath() {
    checkThat(
      Match.self,
      hasTypes: [Match.self, Player?.self],
      forPath: [codingKey("winner")]
    )

    checkThat(
      JsonValue.self,
      hasTypes: [JsonValue.self, JsonValue.self],
      forPath: [codingKey(333)]
    )
  }

  func testPathInsideArray() {
  checkThat(
    [Match].self,
    hasTypes: [
      [Match].self,
      Match.self,
      [Player].self,
      Player.self
    ],
    forPath: [
      codingKey(500),
      codingKey("players"),
      codingKey(22)
    ]
  )
}

  func testComplexPath1() {
    checkThat(
      Match.self,
      hasTypes: [
        Match.self,
        [Player].self,
        Player.self,
        Player.Name.self,
        String.self
      ],
      forPath: [
        codingKey("players"),
        codingKey(22),
        codingKey("name"),
        codingKey("lastName")
      ]
    )
  }

  func testComplexPath2() {
    checkThat(
      Match.self,
      hasTypes: [
        Match.self,
        Player?.self,
        Double?.self
      ],
      forPath: [
        codingKey("winner"),
        codingKey("height")
      ]
    )
  }

  func testInvalidPath() {
    checkThat(
      Match.self,
      hasTypes: nil,
      forPath: [
        codingKey("players"),
        codingKey(22),
        codingKey("salary"),
        codingKey("frequency")
      ]
    )
  }

  private func checkThat(_ type: any CodingKeysReflector.Type,
                         hasTypes expectedTypes: [CodingKeysReflector.Type]?,
                         forPath path: [CodableVersionOf.CodingKey],
                         file: StaticString = #file,
                         line: UInt = #line) {
    let actualTypes = type.types(forCodingPath: path.map(\.asPlainKey))

    XCTAssertEqual(
      actualTypes.asSuccess?.map { TypeName(type: $0) },
      expectedTypes?.map { TypeName(type: $0) },
      file: file,
      line: line
    )
  }
}
