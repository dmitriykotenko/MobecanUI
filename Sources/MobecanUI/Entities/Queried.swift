//  Copyright © 2020 Mobecan. All rights reserved.


public struct Queried<Query, Result>: Lensable, CustomStringConvertible {

  public var query: Query
  public var result: Result

  public init(query: Query,
              result: Result) {
    self.query = query
    self.result = result
  }
  
  public var description: String {
    "Query: \(query)\n" +
    "Result: \(result)"
  }
  
  public func map<OtherResult>(_ transform: (Result) -> OtherResult) -> Queried<Query, OtherResult> {
    Queried<Query, OtherResult>(
      query: query,
      result: transform(result)
    )
  }
}


extension Queried: Equatable where Query: Equatable, Result: Equatable {}
extension Queried: Hashable where Query: Hashable, Result: Hashable {}
extension Queried: Codable where Query: Codable, Result: Codable {}
