//  Copyright © 2020 Mobecan. All rights reserved.


public extension Optional {
  
  var asArray: [Wrapped] { map { [$0] } ?? [] }
}
