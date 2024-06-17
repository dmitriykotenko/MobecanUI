// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


class DeserializationTester: XCTestCase {

  let corruptedJson1 = ""

  let errorWhenDecodingCorruptedJson1 = CodableVersionOf.DecodingError.dataCorrupted(
    context: .init(
      codingPath: [],
      debugDescription: "The given data was not valid JSON.",
      underlyingError:
        NSError(
          domain: "NSCocoaErrorDomain",
          code: 3840,
          userInfo: ["NSDebugDescription": "Unexpected end of file"]
        )
        .stableDescription
    )
  )

  let corruptedJson2 = "John Smith"

  let errorWhenDecodingCorruptedJson2 = CodableVersionOf.DecodingError.dataCorrupted(
    context: .init(
      codingPath: [],
      debugDescription: "The given data was not valid JSON.",
      underlyingError:
        NSError(
          domain: "NSCocoaErrorDomain",
          code: 3840,
          userInfo: [
            "NSJSONSerializationErrorIndex": 0,
            "NSDebugDescription": "Unexpected character \'J\' around line 1, column 1.",
          ]
        )
        .stableDescription
    )
  )

  func check<DeserializedType: Decodable & Equatable>(
    deserializedType: DeserializedType.Type,
    jsonString: String,
    expectedDecodingError: CodableVersionOf.DecodingError,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    check(
      deserializedType: deserializedType,
      jsonString: jsonString,
      expectedResult: .failure(
        .decodingError(
          deserializedType: .init(type: deserializedType),
          decodingError: expectedDecodingError
        )
      ),
      file: file,
      line: line
    )
  }

  func check<DeserializedType: Decodable & Equatable>(
    deserializedType: DeserializedType.Type,
    jsonString: String,
    expectedResult: Result<DeserializedType, DeserializationError>,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    func report(_ message: String) {
      XCTFail(message, file: file, line: line)
    }

    switch jsonString.data(using: .utf8) {
    case nil:
      report("Не удалось конвертировать JSON-строку в Data")
    case let jsonData?:
      switch (DeserializedType.fromData(jsonData), expectedResult) {
      case (.success, .failure):
        report("При десериализации не возникло ошибок")
      case (.failure(let error), .success):
        report(
          """
          При десериализации возникла ошибка:
          \(error.toJsonString(outputFormatting: [.prettyPrinted, .sortedKeys]))
          """
        )
      case (.success(let actualValue), .success(let expectedValue)):
        if actualValue != expectedValue {
          report(
            """
            При десериализации получился такой объект:
            \(actualValue)

            А ожидался такой:
            \(expectedValue)
            """
          )
        }
      case (.failure(let actualError), .failure(let expectedError)):
        if actualError != expectedError {
          report(
            """
            Пришла ошибка:
            \(actualError.toJsonString(outputFormatting: [.prettyPrinted, .sortedKeys]))

            А ожидалась ошибка:
            \(expectedError.toJsonString(outputFormatting: [.prettyPrinted, .sortedKeys]))
            """
          )
        }
//
//        report(actualError.formattedForTestReport())
      }
    }
  }

  func codingKey(_ index: Int) -> CodableVersionOf.CodingKey {
    .init(
      originalCodingKeyType: "_JSONKey",
      intValue: index,
      stringValue: "Index \(index)"
    )
  }

  func codingKey(_ propertyName: String) -> CodableVersionOf.CodingKey {
    .init(
      originalCodingKeyType: "CodingKeys",
      stringValue: propertyName
    )
  }
}
