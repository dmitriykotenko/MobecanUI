// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


extension CancelOr: AutoGeneratable where Value: AutoGeneratable {

  public final class BuiltinGenerator: MobecanGenerator<CancelOr<Value>> {

    public enum Cases: CaseIterable {
      case cancel
      case value
    }

    public final class Generator_value: FunctionalGenerator<Value> {

      public final class Builtin: MobecanGenerator<Value> {

        public var _0: MobecanGenerator<Value>

        public init(_ _0: MobecanGenerator<Value> = Value.defaultGenerator) {
          self._0 = _0
          super.init()
        }

        public static func using(
          _ _0: MobecanGenerator<Value> = Value.defaultGenerator
        ) -> Builtin {
          .init(_0)
        }

        override public func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<Value>> {
          factory.generate(via: _0)
        }
      }

      public static func builtin(
        _ _0: MobecanGenerator<Value> = Value.defaultGenerator
      ) -> Generator_value {
        .init {
          Builtin(_0).generate(factory: $0)
        }
      }
    }

    public var `case`: MobecanGenerator<Cases>
    public var value: Generator_value

    public init(case: MobecanGenerator<Cases> = .unsafeEither(Cases.allCases),
                value: Generator_value = .builtin()) {
      self.case = `case`
      self.value = value
      super.init()
    }

    public static func using(
      case: MobecanGenerator<Cases> = .unsafeEither(Cases.allCases),
      value: Generator_value = .builtin()
    ) -> BuiltinGenerator {
      .init(
        case: `case`,
        value: value
      )
    }

    override public func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<CancelOr<Value>>> {
      factory
        .generate(via: `case`)
        .flatMapSuccess { [value] in
          switch $0 {
          case .cancel:
            return .just(.success(.cancel))
          case .value:
            return value.generate(factory: factory).mapSuccess {
              .value($0)
            }
          }
        }
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}
