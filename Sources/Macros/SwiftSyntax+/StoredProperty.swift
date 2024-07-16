// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct StoredProperty: Equatable, Hashable, Codable {

  var name: String
  var type: String

  init(name: String, type: String) {
    self.name = name
    self.type = type
  }

  init?(name: String?, type: String?) {
    guard let name, let type else { return nil }
    self.name = name
    self.type = type
  }

  var letDeclaration: String { declaration(prefix: "let") }
  var varDeclaration: String { declaration(prefix: "var") }
  var lazyVarDeclaration: String { declaration(prefix: "lazy var") }

  func declaration(prefix: String) -> String {
    "\(prefix) \(name): \(type)"
  }

  func asFunctionParameter(outerName: String?? = .none,
                           innerName: String?? = .none,
                           defaultValue: String? = nil) -> FunctionParameter {
    .init(
      outerName: outerName ?? name,
      innerName: innerName ?? name,
      type: type,
      defaultValue: defaultValue
    )
  }

  func replacingName(usingCodingKeys codingKeys: Set<EnumCase>) -> Self {
    var result = self

    let rawValue = codingKeys.first { $0.name == name }?.rawValue?
      .trimmingCharacters(in: .init(charactersIn: "\""))
      .trimmingCharacters(in: .whitespacesAndNewlines)

    result.name = rawValue ?? name

    return result
  }

  func with(typeContainer: String) -> Self {
    var result = self
    result.type = typeContainer + "<" + type  + ">"
    return result
  }
}
