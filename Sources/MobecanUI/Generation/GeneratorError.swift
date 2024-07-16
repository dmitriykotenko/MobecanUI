// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


public struct GeneratorError: Error, Equatable, Hashable, Codable {

  public var message: String

  public init(message: String) {
    self.message = message
  }
}
