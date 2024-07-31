// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension DeclGroupSyntax {

  var inferredMemberwiseInitializer: Function? {
    asStruct?.inferredMemberwiseInitializer
    ?? asClass?.inferredMemberwiseInitializer
  }

  var macroGeneratedMemberwiseInitializer: Function? {
    if contains(attribute: "MemberwiseInit") {
      inferredMemberwiseInitializer?
        .prepending(visibilities: visibilityModifiers)
        .withOpenVisibilityConvertedToPublic()
        .withoutNonPublicVisibility()
    } else {
      nil
    }
  }
}
