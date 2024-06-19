// Copyright © 2024 Mobecan. All rights reserved.


extension Optional {

  var asArray: [Wrapped] { map { [$0] } ?? [] }
}
