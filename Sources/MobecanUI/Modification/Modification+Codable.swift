//  Copyright © 2020 Mobecan. All rights reserved.


extension Modification: Codable where Value: Codable {

  public enum CodingKeys: String, CodingKey {
    case kind
    case content
  }

  private enum Kind: String, Codable {
    case create
    case update
    case delete
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let kind = try container.decode(Kind.self, forKey: .kind)

    switch kind {
    case .create:
      let value = try container.decode(Value.self, forKey: .content)
      self = .create(value)
    case .update:
      let update = try container.decode(Update<Value>.self, forKey: .content)
      self = .update(update)
    case .delete:
      let value = try container.decode(Value.self, forKey: .content)
      self = .delete(value)
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    switch self {
    case .create(let value):
      try container.encode(Kind.create, forKey: .kind)
      try container.encode(value, forKey: .content)
    case .update(let update):
      try container.encode(Kind.update, forKey: .kind)
      try container.encode(update, forKey: .content)
    case .delete(let value):
      try container.encode(Kind.delete, forKey: .kind)
      try container.encode(value, forKey: .content)
    }
  }
}
