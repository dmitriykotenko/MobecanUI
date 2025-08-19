// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension DeclModifierSyntax {

  var isVisibilityModifier: Bool {
    ["private", "fileprivate", "internal", "public", "open"].contains(name.text)
  }

  var asMemberwiseInitVisibilityModifier: Self? {
    switch name.tokenKind {
    case .keyword(.open), .keyword(.public): .init(name: .keyword(.public))
    case .keyword(.internal), .keyword(.fileprivate): self
    case .keyword(.private): nil
    default: nil
    }
  }

  var isVisibilityModifier2: Bool {
    switch name.tokenKind {
    case .keyword(.open),
         .keyword(.public),
         .keyword(.internal),
         .keyword(.fileprivate),
         .keyword(.private):
      true
    default:
      false
    }
  }
}
