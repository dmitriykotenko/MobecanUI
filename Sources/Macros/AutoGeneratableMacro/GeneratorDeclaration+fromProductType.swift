// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension GeneratorDeclaration {

  static func from(product: ProductType,
                   className: String,
                   parentClassName: String,
                   genericArgumentsCondition: String? = nil) -> Self {
    .init(
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
            name: $0.initializationName == nil ? "_\($0.name)" : $0.name,
            type: "MobecanGenerator<\($0.type)"
          )
        }
      )
    )
  }

  private static func bodyOfGenerationMethod(ofProduct product: ProductType,
                                             nestedGenerators: [StoredProperty]) -> String {
    let singles = nestedGenerators.map { "factory.generate(via: \($0.name))" }

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
