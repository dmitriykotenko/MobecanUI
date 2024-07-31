// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public struct MobecanDiagnosticMessage: DiagnosticMessage, Lensable {

  public var message: String
  public var diagnosticID: MessageID
  public var severity: DiagnosticSeverity

  static let duplicatedEnumCaseNames = MobecanDiagnosticMessage(
    message: "Макрос @DerivesAutoGeneratable не поддерживает енумы с одноимёнными кейсами.",
    diagnosticID: .init(domain: "generator-macro", id: "duplicated-case-names"),
    severity: .error
  )

  static let tuplesAmongStoredProperties = MobecanDiagnosticMessage(
    message: "Макрос @DerivesAutoGeneratable не поддерживает тьюплы.",
    diagnosticID: .init(domain: "generator-macro", id: "tuples-among-stored-properties"),
    severity: .error
  )
}
