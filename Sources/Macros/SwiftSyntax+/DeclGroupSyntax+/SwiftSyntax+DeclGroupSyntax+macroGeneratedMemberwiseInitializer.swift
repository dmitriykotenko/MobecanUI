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

  var macroGeneratedMemberwiseInitializer2: InitializerDeclSyntax? {
    if contains(attribute: "MemberwiseInit") {
      inferredMemberwiseInitializer4
    } else {
      nil
    }
  }

  var inferredMemberwiseInitializer2: InitializerDeclSyntax? {
    asStruct2?.buildMemberwiseInitializer2()
    ?? asClass2?.buildMemberwiseInitializer2()
  }
}
