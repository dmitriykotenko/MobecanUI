// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


struct EnumCase: Equatable, Hashable, Codable {

  struct Parameter: Equatable, Hashable, Codable {
    var name: String?
    var type: String
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
}
