// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension FunctionParameterSyntax {

  var asFunctionParameter: FunctionParameter {
    .init(
      outerName: firstName.text.nilIfUnderscore,
      innerName: (secondName ?? firstName).text.nilIfUnderscore,
      type: type.trimmedDescription,
      defaultValue: defaultValue?.value.trimmedDescription
    )
  }

  func asBetterFunctionParameter(index: Int) -> BetterFunctionParameter {
    asFunctionParameter.asBetterParameter(index: index)
  }
}
