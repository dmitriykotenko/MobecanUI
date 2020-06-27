//  Copyright © 2020 Mobecan. All rights reserved.


public extension Optional where Wrapped == String {

  var isNilOrEmpty: Bool {
    return self == nil || (self?.isEmpty == true)
  }
}
