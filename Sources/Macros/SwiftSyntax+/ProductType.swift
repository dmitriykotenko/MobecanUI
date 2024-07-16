// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


/// Абстрактный тип данных, объединяющий структуры, классы и именованные тьюплы.
struct ProductType: Equatable, Hashable, Codable {

  struct Member: Equatable, Hashable, Codable {

    var initializationName: String?
    var name: String
    var type: String

    var asStoredProperty: StoredProperty {
      .init(
        kind: "var",
        name: name,
        type: type, 
        defaultValue: nil
      )
    }

    func asFunctionParameter(outerName: String?? = .none,
                             innerName: String?? = .none,
                             defaultValue: String? = nil) -> FunctionParameter {
      .init(
        outerName: outerName ?? initializationName,
        innerName: innerName ?? name,
        type: type,
        defaultValue: defaultValue
      )
    }

    func with(typeContainer: String) -> Self {
      var result = self
      result.type = typeContainer + "<" + type  + ">"
      return result
    }
  }

  var nominalName: String? = nil
  var members: [Member] = []

  func name() -> String {
    nominalName ?? structuralName()
  }

  func structuralName() -> String {
    members
      .map { [$0.initializationName, $0.type].filterNil().mkStringWithColon() }
      .mkString(
        start: "(",
        separator: ", ",
        end: ")"
      )
  }

  func initializationWithAnonymousArguments() -> String {
    initialization(
      withArguments: members.asAnonymousArguments
    )
  }

  func memberwiseInitialization() -> String {
    initialization(withArguments: members.map(\.name))
  }

  func initialization(withArguments arguments: [String]) -> String {
    [
      nominalName,
      members.initialization(withValues: arguments)
    ]
    .filterNil().mkString().compactifiedIfShort
  }
}


extension Array<ProductType.Member> {

  func initialization(withValues values: [String]) -> String {
    zip(self, values)
      .map { "  " + $0.asFunctionParameter().initialization(withValue: $1) }
      .mkStringWithCommaAndNewLine(start: "(\n", end: "\n)")
  }
}
