//  Copyright © 2020 Mobecan. All rights reserved.


public struct Noun {
  
  public let initialForm: String
  public let zero: String
  public let few: String
  public let many: String
  
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
