//  Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func flatten<Value>() -> [Value] where Element == [Value] { flatMap { $0 } }
  
  func flatJoined<NestedElement>(start: NestedElement? = nil,
                                 separator: NestedElement? = nil,
                                 end: NestedElement? = nil) -> [NestedElement]
    where Element == [NestedElement] {
      
      flatJoined(start: start, separator: { separator }, end: end)
  }
  
  func flatJoined<NestedElement>(start: NestedElement? = nil,
                                 separator: () -> NestedElement? = { nil },
                                 end: NestedElement? = nil) -> [NestedElement]
    where Element == [NestedElement] {
      
      let nonEmpty = filter { $0.isNotEmpty }
      let allButLast = nonEmpty.dropLast().flatMap { $0 + separator().asArray }
      
      return start.asArray +
        allButLast +
        nonEmpty.last.asArray.flatten() +
        end.asArray
  }
}
