// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension GeneratorDeclaration {

  static func from(product: ProductType,
                   visibilityModifiers: [VisibilityModifier],
                   className: String,
                   parentClassName: String,
                   genericArgumentsCondition: String? = nil) -> Self {
    .init(
      visibilityModifiers: visibilityModifiers,
      className: className,
      inheritedClassName: parentClassName,
      valueType: product.name(),
      genericArgumentsCondition: genericArgumentsCondition,
      initializerParameters: product.members.map {
        $0
          .asFunctionParameter(
            outerName: $0.initializationName,
            innerName: $0.initializationName == nil ? "_\($0.name)" : $0.name,
            defaultValue: "AsAutoGeneratable<\($0.type)>.defaultGenerator"
          )
          .with(typeContainer: "MobecanGenerator")
      },
      bodyOfGenerateMethod: bodyOfGenerationMethod(
        ofProduct: product,
        nestedGenerators: product.members.map {
          .init(
            kind: "var",
            name: $0.initializationName == nil ? "_\($0.name)" : $0.name,
            type: "MobecanGenerator<\($0.type)>",
            defaultValue: nil
          )
        }
      )
    )
  }

  private static func bodyOfGenerationMethod(ofProduct product: ProductType,
                                             nestedGenerators: [StoredProperty]) -> String {
    switch nestedGenerators.count {
    case 1:
      return bodyOfGenerationMethod(ofProduct: product, singleNestedGenerator: nestedGenerators[0])
    default:
      return bodyOfGenerationMethod(ofProduct: product, multipleNestedGenerators: nestedGenerators)
    }
  }

  private static func bodyOfGenerationMethod(ofProduct product: ProductType,
                                             singleNestedGenerator: StoredProperty) -> String {
    """
    factory
      .generate(via: \(singleNestedGenerator.name))
      .mapSuccess {
    \("    ".prependingToLines(of: product.initializationWithAnonymousArguments()))
      }
    """
  }

  private static func bodyOfGenerationMethod(ofProduct product: ProductType,
                                             multipleNestedGenerators: [StoredProperty]) -> String {
    let singles = multipleNestedGenerators.map { "factory.generate(via: \($0.name))" }

    return """
      Single
        .zip(
      \("    ".prependingToLines(of: singles.mkStringWithCommaAndNewLine()))
        )
        .map {
          zip(\(singles.asAnonymousArguments.mkStringWithComma()))
        }
        .mapSuccess {
      \("    ".prependingToLines(of: product.initializationWithAnonymousArguments()))
        }
      """
  }
}
