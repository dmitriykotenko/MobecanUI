//  Copyright © 2020 Mobecan. All rights reserved.


extension Result {

  var isSuccess: Bool {
    switch self {
    case .success:
      return true
    case .failure:
      return false
    }
  }

  var isFailure: Bool { !isSuccess }
}
