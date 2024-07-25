// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import NonEmpty
import RxSwift


extension EmailAddress: AutoGeneratable {

  public class BuiltinGenerator: MobecanGenerator<EmailAddress> {

    public var unsanitizedString: MobecanGenerator<String>

    public init(unsanitizedString: MobecanGenerator<String> = String.defaultGenerator) {
      self.unsanitizedString = unsanitizedString
    }

    override public func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<EmailAddress>> {
      factory.generate(via: unsanitizedString).mapSuccess {
        .init(unsanitizedString: $0)
      }
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}
