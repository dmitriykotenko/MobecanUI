// Copyright © 2020 Mobecan. All rights reserved.

import Foundation


public extension Encodable {
  
  var jsonDescription: String {
    let description = try? String(data: JSONEncoder().encode(self), encoding: .utf8)
    
    return description ?? "\(Self.self)"
  }

  func toJsonString(encoder: JSONEncoder = JSONEncoder(),
                    outputFormatting: JSONEncoder.OutputFormatting = []) -> String {
    encoder.outputFormatting = outputFormatting

    let data = try? encoder.encode(self)
    let string = data.flatMap { String(data: $0, encoding: .utf8) }

    return string ?? ""
  }

  func toJsonValue() -> JsonValue {
    let string = toJsonString()
    let data = string.data(using: .utf8)

    let maybeJsonValue = data.map { JsonValue.fromData($0) }

    switch maybeJsonValue {
    case .success(let jsonValue):
      return jsonValue
    default:
      return .null
    }
  }
}
