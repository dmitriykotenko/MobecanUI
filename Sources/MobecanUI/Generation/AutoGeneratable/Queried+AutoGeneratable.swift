// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


extension Queried: AutoGeneratable where Query: AutoGeneratable, Result: AutoGeneratable {

  public final class BuiltinGenerator: MobecanGenerator<Queried<Query, Result>> {

    public var query: MobecanGenerator<Query>
    public var result: MobecanGenerator<Result>

    public init(query: MobecanGenerator<Query> = Query.defaultGenerator,
                result: MobecanGenerator<Result> = Result.defaultGenerator) {
      self.query = query
      self.result = result
      super.init()
    }

    public static func using(
      query: MobecanGenerator<Query> = Query.defaultGenerator,
      result: MobecanGenerator<Result> = Result.defaultGenerator
    ) -> BuiltinGenerator {
      .init(
        query: query,
        result: result
      )
    }

    override public func generate(factory: any GeneratorsFactory) -> Single<GeneratorResult<Queried<Query, Result>>> {
      Single
        .zip(
          factory.generate(via: query),
          factory.generate(via: result)
        )
        .map { zip($0, $1) }
        .mapSuccess {
          .init(
            query: $0,
            result: $1
          )
        }
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}
