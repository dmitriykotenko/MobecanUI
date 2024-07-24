// Copyright © 2020 Mobecan. All rights reserved.


public extension Result {

  var isSuccess: Bool {
    switch self {
    case .success:
      return true
    case .failure:
      return false
    }
  }

  func isSuccessWhere(_ condition: (Success) -> Bool) -> Bool {
    switch self {
    case .success(let value) where condition(value):
      return true
    default:
      return false
    }
  }

  func isNotNilSuccess<Element>(and condition: (Element) -> Bool = { _ in true }) -> Bool where Success == Element? {
    switch self {
    case .success(let value?) where condition(value):
      return true
    default:
      return false
    }
  }

  var isError: Bool { !isSuccess }
}


public extension Result where Success: Equatable {

  func isSuccess(_ value: Success) -> Bool {
    isSuccessWhere { $0 == value }
  }
}
