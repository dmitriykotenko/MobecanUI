// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct Tuple: Equatable, Hashable, Codable {

  struct Member: Equatable, Hashable, Codable {
    
    var name: String?
    var type: String

    func asStoredProperty(defaultName: String) -> StoredProperty {
      .init(
        name: name ?? defaultName,
        type: type
      )
    }
  }

  var members: [Member]

  var asProductType: ProductType {
    .init(
      nominalName: nil,
      members: members.enumerated().map {
        .init(
          initializationName: $1.name,
          name: $1.name ?? "\($0)",
          type: $1.type
        )
      }
    )
  }

  func normalizedName() -> String {
    switch members.count {
    case 0:
      return "Void"
    case 1:
      return members[0].type
    default:
      return name()
    }
  }

  func name() -> String {
    members.mkString(
      start: "(",
      format: {
        [$0.name, $0.type].filterNil().mkString(separator: ": ")
      },
      separator: ", ",
      end: ")"
    )
  }
}
