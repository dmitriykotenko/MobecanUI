// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension EnumDeclSyntax {

  var cases: [EnumCaseDeclSyntax] {
    memberBlock.members.compactMap {
      $0.decl.as(EnumCaseDeclSyntax.self)
    }
  }

  var simplifiedCases: [EnumCase] {
    cases
      .flatMap(\.elements)
      .compactMap {
        EnumCase(
          name: $0.name.text,
          rawValue: $0.rawValue?.value.trimmedDescription,
          parameters:
            $0.parameterClause?.parameters
              .map {
                .init(
                  name: $0.firstName?.text,
                  type: $0.type.trimmedDescription
                )
              }
              ?? []
        )
      }
  }
}
