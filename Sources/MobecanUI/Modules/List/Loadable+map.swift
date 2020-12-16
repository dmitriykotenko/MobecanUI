//  Copyright © 2020 Mobecan. All rights reserved.


public extension Loadable {

  func map<OtherValue>(_ transform: (Value) -> OtherValue) -> Loadable<OtherValue, SomeError> {
    switch self {
    case .isLoading:
      return .isLoading
    case .loaded(let result):
      return .loaded(result.map(transform))
    }
  }

  func nestedMap<NestedElement, OtherElement>(_ transform: (NestedElement) -> OtherElement)
  -> Loadable<[OtherElement], SomeError> where Value == [NestedElement] {
    switch self {
    case .isLoading:
      return .isLoading
    case .loaded(let result):
      return .loaded(result.map { $0.map(transform) })
    }
  }

  func flatMap<OtherValue>(_ transform: (Value) -> Result<OtherValue, SomeError>) -> Loadable<OtherValue, SomeError> {
    switch self {
    case .isLoading:
      return .isLoading
    case .loaded(let result):
      return .loaded(result.flatMap(transform))
    }
  }
}
