// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct Function: MobecanDeclaration, Lensable {

  var signature: FunctionSignature
  var body: String

  var build: DeclSyntax {
    """
    \(raw: buildRawString)
    """
  }

  var buildAsNonCompact: DeclSyntax {
    """
    \(raw: buildNonCompactRawString)
    """
  }

  var buildRawString: String {
    Self.function(signature: signature, body: body)
  }

  var buildNonCompactRawString: String {
    Self.nonCompactFunction(signature: signature, body: body)
  }

  func prepending(visibilities: [VisibilityModifier]) -> Self {
    self[
      \.signature.keywords, { visibilities.map(\.rawValue) + $0 }
    ]
  }

  func withOpenVisibilityConvertedToPublic() -> Self {
    replacing(visibility: .open, by: .public)
  }

  func withoutNonPublicVisibility() -> Self {
    removing(visibilities: [.private, .fileprivate, .internal, .open])
  }

  func replacing(visibility old: VisibilityModifier,
                 by new: VisibilityModifier) -> Self {
    self[
      \.signature.keywords, { $0.map { $0 == old.rawValue ? new.rawValue : $0 } }
    ]
  }

  func removing(visibilities: [VisibilityModifier]) -> Self {
    let unwantedKeywords = visibilities.map(\.rawValue).asSet

    return self[
      \.signature.keywords, { $0.filterNot { unwantedKeywords.contains($0) }}
    ]
  }
}


extension Function {

  static func memberwiseInit(storedProperties: [StoredProperty]) -> Self {
    let parameters = storedProperties
      .filter(\.canBeInitialized)
      .map {
        $0.asFunctionParameter(defaultValue: .some($0.defaultValue ?? $0.implicitDefaultValue))
      }
      .map(\.withEscapingTypeIsNecessary)

    return Function(
      signature: .init(
        keywords: [],
        name: "init",
        parameters: parameters
      ),
      body: """
      \(parameters
        .compactMap(\.innerName)
        .map { "self.\($0) = \($0)" }
        .mkStringWithNewLine()
      )
      """
    )
  }
}
