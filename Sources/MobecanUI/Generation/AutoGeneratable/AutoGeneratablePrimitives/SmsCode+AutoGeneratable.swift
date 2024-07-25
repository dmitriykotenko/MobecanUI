// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import NonEmpty
import RxSwift


extension SmsCode: AutoGeneratable {

  public class BuiltinGenerator: MobecanGenerator<SmsCode> {

    public var digits: MobecanGenerator<String>

    public init(digits: MobecanGenerator<String> = String.defaultGenerator) {
      self.digits = digits
    }

    override public func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<SmsCode>> {
      factory.generate(via: digits).mapSuccess { .init($0) }
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}
