// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct EnumCase: Equatable, Hashable, Codable {

  struct Parameter: Equatable, Hashable, Codable {

    var name: String?
    var type: String

    func initialization(withValue value: String) -> String {
      [name, value].filterNil().mkStringWithColon()
    }

    var asTupleMember: Tuple.Member {
      .init(name: name, type: type)
    }

    func asStoredProperty(defaultName: String) -> StoredProperty {
      .init(
        kind: "var",
        name: name ?? defaultName,
        type: type,
        defaultValue: nil
      )
    }
  }

  var name: String
  var rawValue: String?
  var parameters: [Parameter]

  init(name: String, 
       rawValue: String? = nil,
       parameters: [Parameter]) {
    self.name = name
    self.rawValue = rawValue
    self.parameters = parameters
  }

  var dotName: String { "." + name }

  var parametersAsTuple: Tuple {
    .init(members: parameters.map(\.asTupleMember))
  }

  var withoutParameters: Self {
    var result = self
    result.parameters = []
    return result
  }

  var declaration: String {
    "case " + name + (parameters.isEmpty ? "" : parametersAsTuple.name())
  }

  func initialization(fromSingleParameter parameterValue: String) -> String {
    dotName + "(" + parameters[0].initialization(withValue: parameterValue) + ")"
  }

  func initialization(fromTuple tuple: String) -> String {
    if parameters.isEmpty {
      return dotName
    } else {
      return parameters.enumerated()
        .map { $1.initialization(withValue: tuple + "." + ($1.name ?? "\($0)")) }
        .mkStringWithComma(start: dotName + "(", end: ")")
    }
  }
}
