//  Copyright © 2020 Mobecan. All rights reserved.


public extension String {

  var isBlank: Bool { trimmingBlanks.isEmpty }

  var isNotBlank: Bool { !isBlank }

  var notBlankOrNil: String? {
    isNotBlank ? self : nil
  }

  func notBlank(or defaultValue: String) -> String {
    isNotBlank ? self : defaultValue
  }
}


public extension Optional where Wrapped == String {

  var isNilOrBlank: Bool {
    self == nil || (self?.isBlank == true)
  }

  var notBlankOrNil: String? {
    isNilOrBlank ? nil : self
  }

  func notBlank(or defaultValue: String) -> String {
    filter { $0.isNotBlank } ?? defaultValue
  }
}


public extension Array where Element == String {

  func filterNotBlank() -> [String] {
    filter { $0.isNotBlank }
  }
}


public extension Array where Element == String? {

  func filterNotBlank() -> [String] {
    compactMap { $0.notBlankOrNil }
  }
}
