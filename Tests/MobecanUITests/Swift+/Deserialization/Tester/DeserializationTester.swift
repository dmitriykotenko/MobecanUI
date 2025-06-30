// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift
import CustomDump

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
            \("Неправильный результат десериализации:\n".prependTo(diff(expectedValue, actualValue)) ?? "")
            
            При десериализации получился такой объект:
            \(actualValue)

            А ожидался такой:
            \(expectedValue)            
            """
          )
        }
      case (.failure(let actualError), .failure(let expectedError)):
        if actualError != expectedError {
          let expectedErrorJson = expectedError.toJsonValue()
          let actualErrorJson = actualError.toJsonValue()
          let expectedErrorJsonString = expectedError.toJsonString(outputFormatting: [.prettyPrinted, .sortedKeys])
          let actualErrorJsonString = actualError.toJsonString(outputFormatting: [.prettyPrinted, .sortedKeys])

          report(
            """
            \("Не та ошибка:\n".prependTo(diff(expectedErrorJson, actualErrorJson)) ?? "")
            
            Пришла ошибка:
            \(actualErrorJsonString)

            А ожидалась ошибка:
            \(expectedErrorJsonString)
            """
          )
        }
      }
    }
  }

  func codingKey(_ index: Int) -> CodableVersionOf.CodingKey {
    .init(
      originalCodingKeyType: originalTypeOfIntCodingKey,
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

  func unexpectedNullErrorMessage<Value>(exectedType type: Value.Type) -> String {
    let typeName = TypeName(type: type)

    return if #available(iOS 18.0, *) {
      switch typeName {
      case .dictionaryOfStringAndAny:
        "Cannot get keyed decoding container -- found null value instead"
      case .arrayOfAny:
        "Cannot get unkeyed decoding container -- found null value instead"
      default:
        "Cannot get value of type \(typeName.nonQualified) -- found null value instead"
      }
    } else {
      switch typeName {
      case .dictionaryOfStringAndAny:
        "Cannot get keyed decoding container -- found null value instead"
      default:
        "Cannot get unkeyed decoding container -- found null value instead"
      }
    }
  }

  private var originalTypeOfIntCodingKey: String {
    if #available(iOS 18.0, *) {
      "_CodingKey"
    } else {
      "_JSONKey"
    }
  }
}
