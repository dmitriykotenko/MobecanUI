//  Copyright © 2020 Mobecan. All rights reserved.


public extension String {

  var isBlank: Bool {
    trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  var isNotBlank: Bool { !isBlank }
}


public extension Optional where Wrapped == String {

  var isNilOrBlank: Bool {
    self == nil || (self?.isBlank == true)
  }
}
