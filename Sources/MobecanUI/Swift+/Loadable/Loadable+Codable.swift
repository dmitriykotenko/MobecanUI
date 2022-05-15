// Copyright © 2020 Mobecan. All rights reserved.


extension Loadable: Codable where Value: Codable, SomeError: Codable {

  public enum CodingKeys: String, CodingKey {
    case kind
    case resultKind
    case value
    case error
  }

  private enum Kind: String, Codable {
    case isLoading
    case loaded
  }

  private enum ResultKind: String, Codable {
    case success
    case failure
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let kind = try container.decode(Kind.self, forKey: .kind)

    switch kind {
    case .isLoading:
      self = .isLoading
    case .loaded:
      let resultKind = try container.decode(ResultKind.self, forKey: .resultKind)
      
      switch resultKind {
      case .success:
        let value = try container.decode(Value.self, forKey: .value)
        self = .loaded(.success(value))
      case .failure:
        let error = try container.decode(SomeError.self, forKey: .error)
        self = .loaded(.failure(error))
      }
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    switch self {
    case .isLoading:
      try container.encode(Kind.isLoading, forKey: .kind)
    case .loaded(let result):
      try container.encode(Kind.loaded, forKey: .kind)

      switch result {
      case .success(let value):
        try container.encode(ResultKind.success, forKey: .resultKind)
        try container.encode(value, forKey: .value)
      case .failure(let error):
        try container.encode(ResultKind.failure, forKey: .resultKind)
        try container.encode(error, forKey: .error)
      }
    }
  }
}
