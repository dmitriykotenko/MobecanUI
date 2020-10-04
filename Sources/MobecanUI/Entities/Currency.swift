//  Copyright © 2020 Mobecan. All rights reserved.

import Foundation


public enum Currency: String, Equatable, Hashable, Codable {
  
  case rouble
  case dollar

  public var symbol: Character {
    switch self {
    case .rouble:
      return "₽"
    case .dollar:
      return "$"
    }
  }
}
