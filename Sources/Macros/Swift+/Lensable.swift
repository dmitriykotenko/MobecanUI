// Copyright © 2020 Mobecan. All rights reserved.


public protocol Lensable {

  subscript<Value>(_ keyPath: WritableKeyPath<Self, Value>, _ value: Value) -> Self { get }

  subscript<Value>(_ keyPath: WritableKeyPath<Self, Value>, _ transform: (Value) -> Value) -> Self { get }
}


public extension Lensable {

  subscript<Value>(_ keyPath: WritableKeyPath<Self, Value>, _ value: Value) -> Self {
    var result = self
    result[keyPath: keyPath] = value
    return result
  }

  subscript<Value>(_ keyPath: WritableKeyPath<Self, Value>,
                   _ transform: (Value) -> Value) -> Self {
    var result = self
    result[keyPath: keyPath] = transform(result[keyPath: keyPath])
    return result
  }
}
