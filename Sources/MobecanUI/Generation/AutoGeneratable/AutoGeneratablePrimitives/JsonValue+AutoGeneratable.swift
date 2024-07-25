// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import RxSwift


extension JsonValue: AutoGeneratable {

  public class BuiltinGenerator: MobecanGenerator<JsonValue> {

    public enum Cases: CaseIterable {
      case string
      case int
      case double
      case bool
      case object
      case array
      case null
    }

    public var `case`: MobecanGenerator<Cases>
    public var string: MobecanGenerator<String>
    public var int: MobecanGenerator<Int>
    public var double: MobecanGenerator<Double>
    public var bool: MobecanGenerator<Bool>
    public var objectLength: MobecanGenerator<SequenceLength>
    public var arrayLength: MobecanGenerator<SequenceLength>

    init(case: MobecanGenerator<Cases> = .unsafeEither(Cases.allCases),
         string: MobecanGenerator<String> = String.defaultGenerator,
         int: MobecanGenerator<Int> = Int.defaultGenerator,
         double: MobecanGenerator<Double> = Double.defaultGenerator,
         bool: MobecanGenerator<Bool> = Bool.defaultGenerator,
         objectLength: MobecanGenerator<SequenceLength> = SequenceLength.defaultGenerator,
         arrayLength: MobecanGenerator<SequenceLength> = SequenceLength.defaultGenerator) {
      self.case = `case`
      self.string = string
      self.int = int
      self.double = double
      self.bool = bool
      self.objectLength = objectLength
      self.arrayLength = arrayLength
    }

    public static func using(
      case: MobecanGenerator<Cases> = .unsafeEither(Cases.allCases),
      string: MobecanGenerator<String> = String.defaultGenerator,
      int: MobecanGenerator<Int> = Int.defaultGenerator,
      double: MobecanGenerator<Double> = Double.defaultGenerator,
      bool: MobecanGenerator<Bool> = Bool.defaultGenerator,
      objectLength: MobecanGenerator<SequenceLength> = SequenceLength.defaultGenerator,
      arrayLength: MobecanGenerator<SequenceLength> = SequenceLength.defaultGenerator
    ) -> BuiltinGenerator {
      .init(
        case: `case`,
        string: string,
        int: int,
        double: double,
        bool: bool,
        objectLength: objectLength,
        arrayLength: arrayLength
      )
    }
    override public func generate(factory: GeneratorsFactory) -> Single<GeneratorResult<JsonValue>> {
      factory
        .generate(via: `case`)
        .flatMapSuccess { [string, int, double, bool] in
          switch $0 {
          case .string:
            return string.generate(factory: factory).mapSuccess { .string($0) }
          case .int:
            return int.generate(factory: factory).mapSuccess { .int($0) }
          case .double:
            return double.generate(factory: factory).mapSuccess { .double($0) }
          case .bool:
            return bool.generate(factory: factory).mapSuccess { .bool($0) }
          case .object:
            return self.generateObject(factory: factory).mapSuccess { .object($0) }
          case .array:
            return self.generateArray(factory: factory).mapSuccess { .array($0) }
          case .null:
            return .just(.success(.null))
          }
        }
    }
   
    private func generateObject(factory: GeneratorsFactory) -> Single<GeneratorResult<[String: JsonValue]>> {
      [String: JsonValue].BuiltinGenerator(
        count: objectLength,
        key: string,
        value: .rxFunctional { self.generate(factory: $0) }
      )
      .generate(factory: factory)
    }

    private func generateArray(factory: GeneratorsFactory) -> Single<GeneratorResult<[JsonValue]>> {
      [JsonValue].BuiltinGenerator(
        count: objectLength,
        element: .rxFunctional { self.generate(factory: $0) }
      )
      .generate(factory: factory)
    }
  }

  public static var defaultGenerator: BuiltinGenerator { .init() }
}
