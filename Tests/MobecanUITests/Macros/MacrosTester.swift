// Copyright © 2024 Mobecan. All rights reserved.

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MobecanUI


/// Базовый класс для тестирования макросов.
class MacrosTester: XCTestCase {

  func checkThat(code: String,
                 expandsTo expectedExpandedCode: String,
                 withDiagnostics diagnostics: [DiagnosticSpec] = [],
                 file: StaticString = #file,
                 line: UInt = #line) {
    assertMacroExpansion(
      code,
      expandedSource: expectedExpandedCode,
      diagnostics: diagnostics,
      macros: availableMacros,
      file: file,
      line: line
    )
  }

  /// ХАК для передачи доступных типов макросов в функцию `assertMacroExpansion`.
  ///
  /// Xcode 15.4 не хочет импортировать модуль `MobecanUIMacros` в тестовые файлы.
  /// Но в рантайме сами типы макросов Икскод видит,
  /// поэтому ссылки на типы можно получить с помощью функции `_typeByName()`.
  private var availableMacros: [String: Macro.Type] {
    let mangledMarcoNames = [
      "CodingKeysReflection": "15MobecanUIMacros25CodingKeysReflectionMacroV",
      "URL": "15MobecanUIMacros8UrlMacroV",
    ]

    return mangledMarcoNames.compactMapValues { _typeByName($0) as? Macro.Type }
  }
}
