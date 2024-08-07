// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct StoredProperty: Equatable, Hashable, Codable, Lensable {

  var kind: String?
  var name: String
  var type: String
  var defaultValue: String?

  init(kind: String?,
       name: String,
       type: String,
       defaultValue: String?) {
    self.kind = kind
    self.name = name
    self.type = type
    self.defaultValue = defaultValue
  }

  init?(kind: String?,
        name: String?,
        type: String?,
        defaultValue: String?) {
    guard let name, let type else { return nil }

    self.kind = kind
    self.name = name
    self.type = type
    self.defaultValue = defaultValue
  }


  var canBeInitialized: Bool { !canNotBeInitialized }

  var canNotBeInitialized: Bool {
    kind == "let" && defaultValue != nil
  }

  var letDeclaration: String { declaration(prefix: "let") }
  var varDeclaration: String { declaration(prefix: "var") }
  var lazyVarDeclaration: String { declaration(prefix: "lazy var") }

  var isOptionalProperty: Bool {
    TypeSyntax("\(raw: type)").is(OptionalTypeSyntax.self)
  }

  var implicitDefaultValue: String? {
    isOptionalProperty ? "nil" : nil
  }

  func declaration(prefix: String) -> String {
    "\(prefix) \(name): \(type)"
  }

  func asFunctionParameter(outerName: String?? = .none,
                           innerName: String?? = .none,
                           defaultValue: String?? = .none) -> FunctionParameter {
    .init(
      outerName: outerName ?? name,
      innerName: innerName ?? name,
      type: type,
      defaultValue: defaultValue ?? self.defaultValue
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

  func modifyingType(_ modification: (String) -> String) -> Self {
    self[\.type, { modification($0) }]
  }

  func with(typeContainer: String) -> Self {
    self[\.type, typeContainer + "<" + type  + ">"]
  }
}
