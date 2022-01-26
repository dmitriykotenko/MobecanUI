// Copyright © 2020 Mobecan. All rights reserved.


public extension Modification {

  func map<OtherValue>(_ transform: (Value) -> OtherValue) -> Modification<OtherValue> {
    switch self {
    case .create(let value):
      return .create(transform(value))
    case .update(let update):
      return .update(
        old: transform(update.old),
        new: transform(update.new)
      )
    case .delete(let value):
      return .delete(transform(value))
    }
  }

  func mapOld(_ transform: (Value) -> Value) -> Modification<Value> {
    switch self {
    case .create:
      return self
    case .update(let update):
      return .update(.init(
        old: transform(update.old),
        new: update.new
      ))
    case .delete(let value):
      return .delete(transform(value))
    }
  }

  func mapNew(_ transform: (Value) -> Value) -> Modification<Value> {
    switch self {
    case .create(let value):
      return .create(transform(value))
    case .update(let update):
      return .update(
        old: update.old,
        new: transform(update.new)
      )
    case .delete:
      return self
    }
  }

  func withOldValue(_ oldValue: Value?) -> Modification<Value> {
    switch (self, oldValue) {
    case (_, nil):
      return self
    case (.create(let newValue), let oldValue?):
      return .update(old: oldValue, new: newValue)
    case (.update(let update), let oldValue?):
      return .update(old: oldValue, new: update.new)
    case (.delete, let oldValue?):
      return .delete(oldValue)
    }
  }
}
