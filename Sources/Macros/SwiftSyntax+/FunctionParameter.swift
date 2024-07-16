// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct FunctionParameter: Equatable, Hashable, Codable {

  var outerName: String?
  var innerName: String?
  var type: String
  var defaultValue: String?

  init(outerName: String? = nil,
       innerName: String? = nil,
       type: String,
       defaultValue: String? = nil) {
    self.outerName = outerName
    self.innerName = innerName
    self.type = type
    self.defaultValue = defaultValue
  }

  init(name: String? = nil,
       type: String,
       defaultValue: String? = nil) {
    self.outerName = name
    self.innerName = name
    self.type = type
    self.defaultValue = defaultValue
  }

  var declaration: String {
    "\(fullName): \(type)" + (" = ".prependTo(defaultValue) ?? "")
  }

  var fullName: String {
    [unescapedOuterName ?? "_", unescapedInnerName]
      .filterNil()
      .distinct
      .mkString(separator: " ")
  }

  func initialization(withValue value: String) -> String {
    [unescapedOuterName, value].filterNil().mkStringWithColon()
  }

  var unescapedOuterName: String? { outerName?.asUnescapedFunctionParameterName }

  var unescapedInnerName: String? { innerName?.asUnescapedFunctionParameterName }

  var asStoredProperty: StoredProperty? {
    (innerName ?? outerName).map {
      StoredProperty(name: $0, type: type)
    }
  }

  var asProductTypeMember: ProductType.Member? {
    innerName.map {
      ProductType.Member(
        initializationName: outerName,
        name: $0,
        type: type
      )
    }
  }

  func with(typeContainer: String) -> Self {
    var result = self
    result.type = typeContainer + "<" + type  + ">"
    return result
  }
}


private extension String {

  var asUnescapedFunctionParameterName: String {
    let trimmed = trimmingCharacters(in: .init(charactersIn: "`"))

    // Ключевое слово 'case' не нужно эскейпить, если это название аргумента функции.
    return trimmed == "case" ? trimmed : self
  }
}
