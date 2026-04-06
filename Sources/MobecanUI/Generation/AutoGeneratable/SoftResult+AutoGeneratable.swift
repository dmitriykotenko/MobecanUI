// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


/// Реализовано вручную, потому что Xcode 26.3 зацикливается
/// на `@DerivesAutoGeneratable` для generic enum `SoftResult<Success, Failure: Error>`.
extension SoftResult: AutoGeneratable where Success: AutoGeneratable, Failure: AutoGeneratable {

  public final class BuiltinGenerator: MobecanGenerator<SoftResult<Success, Failure>> {

    public enum Cases: CaseIterable {
      case success
      case hybrid
      case failure
    }

    public final class Generator_success: FunctionalGenerator<Success> {

      public final class Builtin: MobecanGenerator<Success> {

        public var _0: MobecanGenerator<Success>

        public init(_ _0: MobecanGenerator<Success> = Success.defaultGenerator) {
          self._0 = _0
          super.init()
        }

        public static func using(
          _ _0: MobecanGenerator<Success> = Success.defaultGenerator
        ) -> Builtin {
          .init(_0)
        }

        override public func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<Success>> {
          factory.generate(via: _0)
        }
      }

      public static func builtin(
        _ _0: MobecanGenerator<Success> = Success.defaultGenerator
      ) -> Generator_success {
        .init {
          Builtin(_0).generate(factory: $0)
        }
      }
    }

    public final class Generator_hybrid: FunctionalGenerator<(value: Success, error: Failure)> {

      public final class Builtin: MobecanGenerator<(value: Success, error: Failure)> {

        public var value: MobecanGenerator<Success>
        public var error: MobecanGenerator<Failure>

        public init(value: MobecanGenerator<Success> = Success.defaultGenerator,
                    error: MobecanGenerator<Failure> = Failure.defaultGenerator) {
          self.value = value
          self.error = error
          super.init()
        }

        public static func using(
          value: MobecanGenerator<Success> = Success.defaultGenerator,
          error: MobecanGenerator<Failure> = Failure.defaultGenerator
        ) -> Builtin {
          .init(value: value, error: error)
        }

        override public func generate(factory: any GeneratorsFactory)
        -> Single<GeneratorResult<(value: Success, error: Failure)>> {
          factory.generate(via: value)
            .flatMapSuccess { [error] value in
              factory.generate(via: error).mapSuccess {
                (value: value, error: $0)
              }
            }
        }
      }

      public static func builtin(
        value: MobecanGenerator<Success> = Success.defaultGenerator,
        error: MobecanGenerator<Failure> = Failure.defaultGenerator
      ) -> Generator_hybrid {
        .init {
          Builtin(
            value: value,
            error: error
          )
          .generate(factory: $0)
        }
      }
    }

    public final class Generator_failure: FunctionalGenerator<Failure> {

      public final class Builtin: MobecanGenerator<Failure> {

        public var _0: MobecanGenerator<Failure>

        public init(_ _0: MobecanGenerator<Failure> = Failure.defaultGenerator) {
          self._0 = _0
          super.init()
        }

        public static func using(
          _ _0: MobecanGenerator<Failure> = Failure.defaultGenerator
        ) -> Builtin {
          .init(_0)
        }

        override public func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<Failure>> {
          factory.generate(via: _0)
        }
      }

      public static func builtin(
        _ _0: MobecanGenerator<Failure> = Failure.defaultGenerator
      ) -> Generator_failure {
        .init {
          Builtin(_0).generate(factory: $0)
        }
      }
    }

    public var `case`: MobecanGenerator<Cases>
    public var success: Generator_success
    public var hybrid: Generator_hybrid
    public var failure: Generator_failure

    public init(case: MobecanGenerator<Cases> = .unsafeEither(Cases.allCases),
                success: Generator_success = .builtin(),
                hybrid: Generator_hybrid = .builtin(),
                failure: Generator_failure = .builtin()) {
      self.case = `case`
      self.success = success
      self.hybrid = hybrid
      self.failure = failure
      super.init()
    }

    public static func using(
      case: MobecanGenerator<Cases> = .unsafeEither(Cases.allCases),
      success: Generator_success = .builtin(),
      hybrid: Generator_hybrid = .builtin(),
      failure: Generator_failure = .builtin()
    ) -> BuiltinGenerator {
      .init(
        case: `case`,
        success: success,
        hybrid: hybrid,
        failure: failure
      )
    }

    override public func generate(factory: any GeneratorsFactory)
    -> Single<GeneratorResult<SoftResult<Success, Failure>>> {
      factory.generate(via: `case`)
        .flatMapSuccess { [success, hybrid, failure] in
          switch $0 {
          case .success:
            return success.generate(factory: factory).mapSuccess {
              .success($0)
            }
          case .hybrid:
            return hybrid.generate(factory: factory).mapSuccess {
              .hybrid(value: $0.value, error: $0.error)
            }
          case .failure:
            return failure.generate(factory: factory).mapSuccess {
              .failure($0)
            }
          }
        }
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}
