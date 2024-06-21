// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct StoredProperty {

  var name: String
  var type: String

  func replacingName(usingCodingKeys codingKeys: Set<EnumCase>) -> Self {
    var result = self

    let rawValue = codingKeys.first { $0.name == name }?.rawValue?
      .trimmingCharacters(in: .init(charactersIn: "\""))
      .trimmingCharacters(in: .whitespacesAndNewlines)

    result.name = rawValue ?? name

    return result
  }

  init(name: String, type: String) {
    self.name = name
    self.type = type
  }

  init?(name: String?, type: String?) {
    guard let name, let type else { return nil }
    self.name = name
    self.type = type
  }
}
