// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct GeneratorDeclaration: MobecanDeclaration {

  var className: String
  var inheritedClassName: String
  var valueType: String
  var genericArgumentsCondition: String? = nil
  var nestedTypes: [String] = []
  var initializerParameters: [FunctionParameter]? = []
  var bodyOfGenerateMethod: String?

  var asProductType: ProductType? {
    switch initializerParameters {
    case let parameters? where parameters.isNotEmpty:
      return .init(
        nominalName: className,
        members: parameters.compactMap(\.asProductTypeMember)
      )
    default:
      return nil
    }
  }

  var storedProperties: [StoredProperty] {
    initializerParameters?.compactMap(\.asStoredProperty) ?? []
  }

  var additionalBody: String?

  var build: DeclSyntax {
    """
    \(raw: buildRawString)
    """
  }

  var buildRawString: String {
    """
    \(buildHeader) {

    \("  ".prependingToLines(of: buildBody))
    }
    """
  }

  private var buildHeader: String {
    [
      "public class \(className): \(inheritedClassName)<\(valueType)>",
      "where ".prependTo(genericArgumentsCondition?.notBlankOrNil)
    ]
    .filterNil()
    .mkStringWithNewLine()
    .asSingleLineIfShort()
  }

  private var buildBody: String {
    [
      nestedTypes.mkStringWithNewParagraph().notBlankOrNil,
      Self.declarationOf(storedProperties: storedProperties),
      initializerParameters.map {
        Self.memberwiseInitializer(parameters: $0, isCompact: true)
      },
      initializerParameters.map {
        Self.memberwiseInitializer(
          parameters: $0,
          customName: "using",
          selfType: className,
          isCompact: true
        )
      },
      declarationOfGenerateMethod,
      additionalBody
    ]
    .filterNil()
    .mkStringWithNewParagraph()
  }

  private var declarationOfGenerateMethod: String? {
    bodyOfGenerateMethod.map {
      Self.function(
        signature: """
        override public func generate(factory: GeneratorsFactory)
        -> Single<GeneratorResult<\(valueType)>>
        """
        .asSingleLineIfShort(),
        body: $0
      )
    }
  }

  func appendingBody(with addition: String) -> Self {
    var result = self

    var additionalBody = result.additionalBody?.appending(String.newLine) ?? ""
    additionalBody += addition
    result.additionalBody = additionalBody

    return result
  }

  func withStaticBuiltin(from nestedGenerator: GeneratorDeclaration) -> Self {
    appendingBody(
      with: Self.function(
        keywords: ["static", "func"],
        name: "builtin",
        parameters: nestedGenerator.initializerParameters ?? [],
        returns: "-> " + className,
        body: [
          ".init {",
          nestedGenerator.asProductType?
            .memberwiseInitialization()
            .appending("\n.generate(factory: $0)")
            .asSingleLineIfShort(lengthThreshold: 80, separator: "")
            .prependingToEveryLine("  ")
            ?? "",
          "}"
        ]
        .mkStringWithNewLine()
      )
    )
  }
}
