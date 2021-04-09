import XCTest


extension Int {

  func times(closure: @escaping () -> ()) {
    (1...self).forEach { _ in closure() }
  }

  func times(_ stopCondition: StopCondition,
             closure: () -> Bool) {
    _ = (1...self).prefix { _ in !stopCondition.shouldStop(closure()) }
  }
}


enum StopCondition {

  case orUntilFalse
  case orUntilTrue

  func shouldStop(_ value: Bool) -> Bool {
    switch self {
    case .orUntilFalse:
      return value == false
    case .orUntilTrue:
      return value == true
    }
  }
}
