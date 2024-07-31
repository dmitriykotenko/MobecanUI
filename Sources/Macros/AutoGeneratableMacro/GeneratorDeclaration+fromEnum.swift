// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension GeneratorDeclaration {

  static let casesSelectorName = "`case`"

  static func from(someEnum: Enum) -> Self? {
    guard !someEnum.isPrimitive else { return nil }

    return .init(
      visibilityModifiers: someEnum.visibilityModifiersForProtocolExtension,
      className: "BuiltinGenerator",
      inheritedClassName: "MobecanGenerator",
      valueType: someEnum.name,
      genericArgumentsCondition:
        someEnum.genericArgumentsConformanceRequirement(protocolName: "AutoGeneratable"),
      nestedTypes: [metaEnum(of: someEnum).description] + someEnum.nonTrivialCases.compactMap {
        generator(forCase: $0, ofEnum: someEnum)?.buildRawString
      },
      initializerParameters: 
        [casesSelector(for: someEnum)] +
        someEnum.nonTrivialCases.map {
          FunctionParameter(
            name: $0.name,
            type: "Generator_\($0.name)",
            defaultValue: ".builtin()"
          )
        },
      bodyOfGenerateMethod: generation(ofEnum: someEnum)
    )
  }

  private static func metaEnum(of someEnum: Enum) -> DeclSyntax {
    let metaEnum = someEnum.withoutAccociatedValues.with(name: "Cases")

    return """
    \(raw: metaEnum.declaration(inheritedProtocols: ["CaseIterable"]))
    """
  }

  private static func casesSelector(for someEnum: Enum) -> FunctionParameter {
    FunctionParameter(
      name: casesSelectorName,
      type: "MobecanGenerator<Cases>",
      defaultValue: ".unsafeEither(Cases.allCases)"
    )
  }

  private static func generator(forCase enumCase: EnumCase,
                                ofEnum someEnum: Enum) -> GeneratorDeclaration? {
    builtinGenerator(forCase: enumCase, ofEnum: someEnum).map { builtinGenerator in
      .init(
        visibilityModifiers: someEnum.visibilityModifiersForProtocolExtension,
        className: "Generator_\(enumCase.name)",
        inheritedClassName: "FunctionalGenerator",
        valueType: enumCase.parametersAsTuple.normalizedName(),
        nestedTypes: [builtinGenerator.buildRawString],
        initializerParameters: nil
      )
      .withStaticBuiltin(from: builtinGenerator)
    }
  }

  private static func builtinGenerator(forCase enumCase: EnumCase,
                                       ofEnum someEnum: Enum) -> GeneratorDeclaration? {
    switch enumCase.parameters.count {
    case 0:
      return nil
    case 1:
      return from(
        singleParameter: enumCase.parameters[0], 
        ofEnum: someEnum
      )
    default:
      return from(
        product: enumCase.parametersAsTuple.asProductType,
        visibilityModifiers: someEnum.visibilityModifiersForProtocolExtension,
        className: "Builtin",
        parentClassName: "MobecanGenerator"
      )
    }
  }

  private static func from(singleParameter: EnumCase.Parameter,
                           ofEnum someEnum: Enum) -> GeneratorDeclaration {
    .init(
      visibilityModifiers: someEnum.visibilityModifiersForProtocolExtension,
      className: "Builtin",
      inheritedClassName: "MobecanGenerator",
      valueType: singleParameter.type,
      initializerParameters: [
        FunctionParameter(
          outerName: singleParameter.name,
          innerName: singleParameter.name ?? "_0",
          type: "MobecanGenerator<\(singleParameter.type)>",
          defaultValue: "AsAutoGeneratable<\(singleParameter.type)>.defaultGenerator"
        )
      ],
      bodyOfGenerateMethod: """
      factory.generate(via: \(singleParameter.name ?? "_0"))
      """
    )
  }

  private static func generation(ofEnum someEnum: Enum) -> String {
    """
    factory
      .generate(via: \(casesSelectorName))
      .flatMapSuccess { \(someEnum.nonTrivialCases.map(\.name).asCaptureSet) in
        switch $0 {
    \(someEnum.cases
      .map { generationOfEnum(fromCase: $0) }
      .mkStringWithNewLine()
      .prependingToEveryLine("    ")
    )
        }
      }
    """
  }

  private static func generationOfEnum(fromCase enumCase: EnumCase) -> String {
    switch enumCase.parameters.count {
    case 0:
      return """
        case \(enumCase.dotName):
          return .just(.success(\(enumCase.dotName)))
        """
    case 1:
      return """
        case \(enumCase.dotName):
          return \(enumCase.name).generate(factory: factory).mapSuccess {
            \(enumCase.initialization(fromSingleParameter: "$0"))
          }
        """
    default:
      return """
        case \(enumCase.dotName):
          return \(enumCase.name).generate(factory: factory).mapSuccess {
            \(enumCase.initialization(fromTuple: "$0"))
          }
        """
    }
  }
}


private extension Enum {

  var visibilityModifiersForProtocolExtension: [VisibilityModifier] {
    visibilityModifiers.contains(where: \.isPublicOrOpen) ?
      [.public] :
      []
  }
}
