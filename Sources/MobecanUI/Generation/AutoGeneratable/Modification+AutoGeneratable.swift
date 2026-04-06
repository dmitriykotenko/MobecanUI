// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


extension Modification: AutoGeneratable where Value: AutoGeneratable {

  public final class BuiltinGenerator: MobecanGenerator<Modification<Value>> {

    public enum Cases: CaseIterable {
      case create
      case update
      case delete
    }

    public final class Generator_create: FunctionalGenerator<Value> {

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
      ) -> Generator_create {
        .init {
          Builtin(_0).generate(factory: $0)
        }
      }
    }

    public final class Generator_update: FunctionalGenerator<Update<Value>> {

      public final class Builtin: MobecanGenerator<Update<Value>> {

        public var _0: MobecanGenerator<Update<Value>>

        public init(_ _0: MobecanGenerator<Update<Value>> = Update<Value>.defaultGenerator) {
          self._0 = _0
          super.init()
        }

        public static func using(
          _ _0: MobecanGenerator<Update<Value>> = Update<Value>.defaultGenerator
        ) -> Builtin {
          .init(_0)
        }

        override public func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<Update<Value>>> {
          factory.generate(via: _0)
        }
      }

      public static func builtin(
        _ _0: MobecanGenerator<Update<Value>> = Update<Value>.defaultGenerator
      ) -> Generator_update {
        .init {
          Builtin(_0).generate(factory: $0)
        }
      }
    }

    public final class Generator_delete: FunctionalGenerator<Value> {

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
      ) -> Generator_delete {
        .init {
          Builtin(_0).generate(factory: $0)
        }
      }
    }

    public var `case`: MobecanGenerator<Cases>
    public var create: Generator_create
    public var update: Generator_update
    public var delete: Generator_delete

    public init(case: MobecanGenerator<Cases> = .unsafeEither(Cases.allCases),
                create: Generator_create = .builtin(),
                update: Generator_update = .builtin(),
                delete: Generator_delete = .builtin()) {
      self.case = `case`
      self.create = create
      self.update = update
      self.delete = delete
      super.init()
    }

    public static func using(
      case: MobecanGenerator<Cases> = .unsafeEither(Cases.allCases),
      create: Generator_create = .builtin(),
      update: Generator_update = .builtin(),
      delete: Generator_delete = .builtin()
    ) -> BuiltinGenerator {
      .init(
        case: `case`,
        create: create,
        update: update,
        delete: delete
      )
    }

    override public func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<Modification<Value>>> {
      factory
        .generate(via: `case`)
        .flatMapSuccess { [create, update, delete] in
          switch $0 {
          case .create:
            return create.generate(factory: factory).mapSuccess {
              .create($0)
            }
          case .update:
            return update.generate(factory: factory).mapSuccess {
              .update($0)
            }
          case .delete:
            return delete.generate(factory: factory).mapSuccess {
              .delete($0)
            }
          }
        }
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}
