// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


extension Result: AutoGeneratable where Success: AutoGeneratable, Failure: AutoGeneratable {

  public final class BuiltinGenerator: MobecanGenerator<Result<Success, Failure>>, Lensable {

    typealias Value = Result<Success, Failure>

    public var isError: MobecanGenerator<IsError>
    public var success: MobecanGenerator<Success>
    public var failure: MobecanGenerator<Failure>

    public init(isError: MobecanGenerator<IsError> = IsError.defaultGenerator,
                success: MobecanGenerator<Success> = Success.defaultGenerator,
                failure: MobecanGenerator<Failure> = Failure.defaultGenerator) {
      self.isError = isError
      self.success = success
      self.failure = failure
    }

    override public func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<Result<Success, Failure>>> {
      factory.generate(via: isError).flatMapSuccess { [success, failure] in
        $0.value ?
          factory.generate(via: failure).mapSuccess { .failure($0) } :
          factory.generate(via: success).mapSuccess { .success($0) }
      }
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}


public extension MobecanGenerator {

  static func builtin<Success: AutoGeneratable, Failure: AutoGeneratable>(
    isError: MobecanGenerator<IsError> = IsError.defaultGenerator,
    success: MobecanGenerator<Success> = Success.defaultGenerator,
    failure: MobecanGenerator<Failure> = Failure.defaultGenerator
  ) -> MobecanGenerator<Result<Success, Failure>>
  where Value == Result<Success, Failure> {
    Result.BuiltinGenerator(
      isError: isError,
      success: success,
      failure: failure
    )
  }
}
