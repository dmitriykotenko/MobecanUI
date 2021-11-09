// Copyright © 2020 Mobecan. All rights reserved.


public extension JsonValue {

  var filterNotNull: JsonValue? {
    switch self {
    case .null:
      return nil
    default:
      return self
    }
  }

  var asBool: Bool? {
    switch self {
    case .bool(let bool):
      return bool
    default:
      return nil
    }
  }

  var asInt: Int? {
    switch self {
    case .int(let int):
      return int
    default:
      return nil
    }
  }

  var asDouble: Double? {
    switch self {
    case .double(let double):
      return double
    default:
      return nil
    }
  }

  var asString: String? {
    switch self {
    case .string(let string):
      return string
    default:
      return nil
    }
  }

  var asArray: [JsonValue]? {
    switch self {
    case .array(let array):
      return array
    default:
      return nil
    }
  }

  var asDictionary: [String: JsonValue]? {
    switch self {
    case .object(let dictionary):
      return dictionary
    default:
      return nil
    }
  }
}
