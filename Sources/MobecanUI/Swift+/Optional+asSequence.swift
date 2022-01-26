// Copyright © 2020 Mobecan. All rights reserved.


public extension Optional {
  
  var asSequence: [Wrapped] { map { [$0] } ?? [] }
}
  
