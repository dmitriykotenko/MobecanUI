// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


@DerivesAutoGeneratable
public enum Modification<Value>: CustomStringConvertible {

  case create(Value)
  case update(Update<Value>)
  case delete(Value)

  public static func update(old: Value, new: Value) -> Modification<Value> {
    .update(.init(old: old, new: new))
  }

  public var description: String {
    switch self {
    case .create(let value):
      return ".create(\(value))"
    case .update(let update):
      return ".update(old: \(update.old), new: \(update.new))"
    case .delete(let value):
      return ".delete(\(value))"
    }
  }
}


extension Modification: Equatable where Value: Equatable {}
extension Modification: Hashable where Value: Hashable {}
