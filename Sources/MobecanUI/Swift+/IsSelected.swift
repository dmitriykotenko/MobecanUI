//  Copyright © 2020 Mobecan. All rights reserved.


public struct IsSelected<Value>: Lensable {
  
  public var value: Value
  public var isSelected: Bool
  
  public init(value: Value,
              isSelected: Bool) {
    self.value = value
    self.isSelected = isSelected
  }
  
  public static func notSelected(_ value: Value) -> IsSelected<Value> {
    .init(
      value: value,
      isSelected: false
    )
  }
  
  public static func selected(_ value: Value) -> IsSelected<Value> {
    .init(
      value: value,
      isSelected: true
    )
  }
}


extension IsSelected: Equatable where Value: Equatable {}
extension IsSelected: Hashable where Value: Hashable {}
extension IsSelected: Codable where Value: Codable {}
