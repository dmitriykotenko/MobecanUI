// Copyright © 2020 Mobecan. All rights reserved.


public extension Modification {

  var oldValue: Value? {
    switch self {
    case .create:
      return nil
    case .update(let update):
      return update.old
    case .delete(let value):
      return value
    }
  }

  var newValue: Value? {
    switch self {
    case .create(let value):
      return value
    case .update(let update):
      return update.new
    case .delete:
      return nil
    }
  }

  var anyValue: Value {
    switch self {
    case .create(let value):
      return value
    case .update(let update):
      return update.old
    case .delete(let value):
      return value
    }
  }
}
