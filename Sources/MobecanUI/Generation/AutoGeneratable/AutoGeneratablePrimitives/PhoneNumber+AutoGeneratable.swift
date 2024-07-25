// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import NonEmpty
import RxSwift


extension PhoneNumber: AutoGeneratable {

  public class BuiltinGenerator: MobecanGenerator<PhoneNumber> {

    public var unsanitizedString: MobecanGenerator<String>

    public init(unsanitizedString: MobecanGenerator<String> = String.defaultGenerator) {
      self.unsanitizedString = unsanitizedString
    }

    override public func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<PhoneNumber>> {
      factory.generate(via: unsanitizedString).mapSuccess {
        .init(unsanitizedString: $0)
      }
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}
