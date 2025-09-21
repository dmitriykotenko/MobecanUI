// Copyright © 2025 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension SyntaxCollection {

  public func filterNot(_ isIncluded: (Element) throws -> Bool) rethrows -> Self {
    try filter { try !isIncluded($0) }
  }
}
