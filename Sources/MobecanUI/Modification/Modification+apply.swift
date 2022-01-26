// Copyright © 2020 Mobecan. All rights reserved.


public extension Modification where Value: Equatable {

  func apply(to array: [Value]) -> [Value] {
    switch self {
    case .create(let newValue):
      return array + [newValue]
    case .update(let update):
      return array.map {
        $0 == update.old ? update.new : $0
      }
    case .delete(let oldValue):
      return array.exclude([oldValue])
    }
  }
}


public extension Modification where Value: Hashable {

  func apply(to set: Set<Value>) -> Set<Value> {
    switch self {
    case .create(let newValue):
      return set.union([newValue])
    case .update(let update):
      return set.contains(update.old) ?
        set.subtracting([update.old]).union([update.new]) :
        set
    case .delete(let oldValue):
      return set.subtracting([oldValue])
    }
  }
}
