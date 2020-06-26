//  Copyright © 2020 Mobecan. All rights reserved.


public struct IsSelected<Value> {
  
  public var value: Value
  public var isSelected: Bool
  
  public init(value: Value,
              isSelected: Bool) {
    self.value = value
    self.isSelected = isSelected
  }
  
  public static func notSelected(_ value: Value) -> IsSelected<Value> {
    return .init(
      value: value,
      isSelected: false
    )
  }
  
  public static func selected(_ value: Value) -> IsSelected<Value> {
    return .init(
      value: value,
      isSelected: true
    )
  }
}
