//  Copyright © 2020 Mobecan. All rights reserved.


public struct Noun: Equatable, Hashable, Codable, Lensable {
  
  public var initialForm: String
  public var zero: String
  public var few: String
  public var many: String
  
  public init(initialForm: String,
              zero: String,
              few: String,
              many: String) {
    self.initialForm = initialForm
    self.zero = zero
    self.few = few
    self.many = many
  }
}
