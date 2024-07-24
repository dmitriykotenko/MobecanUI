// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct Function: MobecanDeclaration {

  var signature: FunctionSignature
  var body: String

  var build: DeclSyntax {
    """
    \(raw: buildRawString)
    """
  }

  var buildRawString: String {
    Self.function(signature: signature, body: body)
  }
}
