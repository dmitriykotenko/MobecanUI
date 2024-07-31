// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension InitializerDeclSyntax {

  var visibilityModifiers: [VisibilityModifier] {
    modifiers
      .filter(\.isVisibilityModifier)
      .compactMap { .init(rawValue: $0.name.text) }
  }

  var asFunctionName: String {
    "init" + (isOptional ? "?" : "")
  }

  var genericParameters: [String] {
    genericParameterClause?.parameters.map(\.trimmedDescription) ?? []
  }

  var genericWhere: String? {
    genericWhereClause?.trimmedDescription
  }

  var isOptional: Bool {
    optionalMark?.text == "?"
  }

  var isThrowing: Bool {
    signature.effectSpecifiers?.throwsClause != nil
  }

  var asFunction: Function {
    .init(
      signature: asFunctionSignature,
      body: body?.trimmedDescription
        .trimmingBlanks
        .trimmingCurlyBraces
        ?? ""
    )
  }

  var asFunctionSignature: FunctionSignature {
    .init(
      keywords: visibilityModifiers.map(\.rawValue),
      name: asFunctionName,
      genericParameters: genericParameters,
      parameters: signature.parameterClause.parameters.map(\.asFunctionParameter),
      beforeReturns: isThrowing ? ["throws"] : [],
      returns: signature.returnClause?.trimmedDescription,
      where: genericWhere
    )
  }
}

