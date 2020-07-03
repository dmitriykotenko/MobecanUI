//  Copyright © 2020 Mobecan. All rights reserved.


public struct Queried<Query, Result>: CustomStringConvertible {

  public let query: Query
  public let result: Result

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


extension Queried: Equatable, Codable where Query: Equatable & Codable, Result: Equatable & Codable {}
