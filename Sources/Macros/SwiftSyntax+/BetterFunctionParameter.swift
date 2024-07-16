// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


/// Вспомогательная структура для более удобной работы с анонимными параметрами некоторых функций.
///
/// Например, у этой функции последние два параметра анонимные:
/// ```
/// func calculate(x: Int, _: Bool, z _: String) {}
/// ```
enum BetterFunctionParameter {

  /// Именованный параметр функции — то есть такой параметр, на который можно сослаться в теле функции.
  /// Большинство параметров всех функций — именованные.
  case named(FunctionParameter, innerName: String)

  /// Анонимный параметр функции — на него нельзя сослаться в теле функциию
  ///
  /// Например, у этой функции последние два параметра анонимные:
  /// ```
  /// func calculate(x: Int, _: Bool, z _: String) {}
  /// ```
  ///
  /// Обычно анонимные параметры используются для явной передачи типа аргумента в функцию-дженерик:
  /// ```
  /// function emptyArray<Value>(_: Value.Type = Value.self) -> [Value] {
  /// }
  /// ...
  /// let x = emptyArray(String.self)
  /// ```
  case unnamed(FunctionParameter, index: Int)

  var originalParameter: FunctionParameter {
    switch self {
    case .named(let parameter, _):
      return parameter
    case .unnamed(let parameter, _):
      return parameter
    }
  }

  var isNamed: Bool {
    switch self {
    case .named:
      return true
    case .unnamed:
      return false
    }
  }

  var innerName: String? {
    switch self {
    case .named(_, let innerName):
      return innerName
    case .unnamed:
      return nil
    }
  }
}


extension FunctionParameter {

  func asBetterParameter(index: Int) -> BetterFunctionParameter {
    switch innerName {
    case let name?:
      return .named(self, innerName: name)
    case nil:
      return .unnamed(self, index: index)
    }
  }
}
