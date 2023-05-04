// Copyright © 2023 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public extension EditorPresenter {

  struct HintFormatter {

    public struct Input {
      public var initialValue: InputValue?
      public var currentValue: SoftResult<OutputValue, SomeError>
      public var doNotDisturbMode: DoNotDisturbMode
      public var intermediateValueProcessingStatus: Loadable<OutputValue, SomeError>?
    }

    public let hint: (Input) -> String?

    public static func alwaysNil() -> HintFormatter {
      .init { _ in nil }
    }
  }
}
