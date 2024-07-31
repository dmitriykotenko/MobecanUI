// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


enum VisibilityModifier: String, Equatable, Hashable, Codable {
  case `private`
  case `fileprivate`
  case `internal`
  case `public`
  case `open`

  var isPublicOrOpen: Bool {
    self == .public || self == .open
  }
}
