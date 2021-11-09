// Copyright © 2020 Mobecan. All rights reserved.


/// Implementation is stolen from Swagger Swift template (https://swagger.io/tools/swagger-codegen)
public enum JsonValue: Equatable, Codable {

  case string(String)
  case int(Int)
  case double(Double)
  case bool(Bool)
  case object([String: JsonValue])
  case array([JsonValue])
  case null

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()

    switch self {
    case .string(let string): try container.encode(string)
    case .int(let int): try container.encode(int)
    case .double(let double): try container.encode(double)
    case .bool(let bool): try container.encode(bool)
    case .object(let object): try container.encode(object)
    case .array(let array): try container.encode(array)
    case .null: try container.encode(String?.none)
    }
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()

    self = try ((try? container.decode(String.self)).map(JsonValue.string))
      .or((try? container.decode(Int.self)).map(JsonValue.int))
      .or((try? container.decode(Double.self)).map(JsonValue.double))
      .or((try? container.decode(Bool.self)).map(JsonValue.bool))
      .or((try? container.decode([String: JsonValue].self)).map(JsonValue.object))
      .or((try? container.decode([JsonValue].self)).map(JsonValue.array))
      .or((container.decodeNil() ? .some(JsonValue.null) : .none))
      .resolve(
        with: DecodingError.typeMismatch(
          JsonValue.self,
          DecodingError.Context(
            codingPath: container.codingPath,
            debugDescription: "Not a JSON value"
          )
        )
      )
  }
}


extension JsonValue: ExpressibleByStringLiteral {

  public init(stringLiteral value: String) {
    self = .string(value)
  }
}


extension JsonValue: ExpressibleByIntegerLiteral {

  public init(integerLiteral value: Int) {
    self = .int(value)
  }
}


extension JsonValue: ExpressibleByFloatLiteral {

  public init(floatLiteral value: Double) {
    self = .double(value)
  }
}


extension JsonValue: ExpressibleByBooleanLiteral {

  public init(booleanLiteral value: Bool) {
    self = .bool(value)
  }
}


extension JsonValue: ExpressibleByDictionaryLiteral {

  public init(dictionaryLiteral elements: (String, Self)...) {
    self = .object([String: Self](uniqueKeysWithValues: elements))
  }
}


extension JsonValue: ExpressibleByArrayLiteral {

  public init(arrayLiteral elements: Self...) {
    self = .array(elements)
  }
}


private extension Optional {

  func or(_ other: Optional) -> Optional {
    switch self {
    case .none: return other
    case .some: return self
    }
  }

  func resolve(with error: @autoclosure () -> Error) throws -> Wrapped {
    switch self {
    case .none: throw error()
    case .some(let wrapped): return wrapped
    }
  }
}
