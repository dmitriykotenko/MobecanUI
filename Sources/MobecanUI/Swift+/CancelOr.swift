// Copyright © 2023 Mobecan. All rights reserved.

import Foundation


public enum CancelOr<Value> {

  case cancel
  case value(Value)
}


extension CancelOr: Equatable where Value: Equatable {}
extension CancelOr: Hashable where Value: Hashable {}
extension CancelOr: Codable where Value: Codable {}
