// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


@DerivesAutoGeneratable
public struct Update<Value>: Lensable, CustomStringConvertible {

  public var old: Value
  public var new: Value

  public init(old: Value, new: Value) {
    self.old = old
    self.new = new
  }

  public var description: String {
    "Update(old: \(old), new: \(new))"
  }
}


extension Update: Equatable where Value: Equatable {}
extension Update: Hashable where Value: Hashable {}
extension Update: Codable where Value: Codable {}
