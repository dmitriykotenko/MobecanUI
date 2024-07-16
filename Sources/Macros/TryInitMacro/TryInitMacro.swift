// Copyright © 2024 Mobecan. All rights reserved.

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


/// Добавляет tryInit-версии для большинства конструкторов класса, структуры или енума.
///
/// tryInit-версия принимает параметры в форме Result<...>,
/// и проверяет, есть ли ошибки среди этих Result-параметров.
///
/// Если есть ошибки, она возвращает `Result.failure(...)`, содержащий все ошибки.
///
/// Если ошибок нет, она вызывает оригинальный конструктор и оборачивает его результат в `Result.success(...)`.
///
/// tryInit-версия предназначена для валидации данных
/// при парсинге ответов сервера или объектов локального хранилища
/// и при редактировании форм.
///
/// Поэтому tryInit-версии не генерируются для конструкторов, в которых есть только анонимные параметры:
/// ```
/// init(a _: Int = 0,
///      _: String,
///      _ _: Bool = false) {
///   ...
/// }
/// ```
public struct TryInitMacro {}


extension TryInitMacro: MemberMacro, MobecanDeclaration {

  public static func expansion(of node: AttributeSyntax,
                               providingMembersOf declaration: some DeclGroupSyntax,
                               in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    try tryInits(declaration: declaration)
  }

  private static func tryInits(declaration: some DeclGroupSyntax) throws -> [DeclSyntax] {
    guard let typeName = declaration.asNamedDeclaration?.name.text
    else { return [] }

    var tryInits = declaration.initializers.compactMap {
      tryInit(from: $0, typeName: typeName)
    }

    if tryInits.isEmpty {
      tryInits += [tryInitFromImplicitInitializer(declaration: declaration)].filterNil()
    }

    return tryInits
  }

  private static func tryInit(from initializer: InitializerDeclSyntax,
                              typeName: String) -> DeclSyntax? {
    tryInit(
      initializerAttributes: initializer.visibilityModifiers.mkStringWithSpace(),
      typeName: typeName,
      isOptionalInitializer: initializer.optionalMark?.text == "?",
      isThrowingInitializer: initializer.signature.effectSpecifiers?.throwsClause != nil,
      originalParameters: initializer.signature.parameterClause.parameters.map(\.asFunctionParameter)
    )
  }

  private static func tryInitFromImplicitInitializer(declaration: some DeclGroupSyntax) -> DeclSyntax? {
    guard let someStruct = declaration.asStruct else { return nil }

    return tryInit(
      initializerAttributes: declaration.visibilityModifiers.mkStringWithSpace(),
      typeName: someStruct.name,
      originalParameters: someStruct.parametersOfImplicitInitializer
    )
  }

  private static func tryInit(initializerAttributes: String? = nil,
                              typeName: String,
                              isOptionalInitializer: Bool = false,
                              isThrowingInitializer: Bool = false,
                              originalParameters: [FunctionParameter]) -> DeclSyntax? {
    let parameters = originalParameters.enumerated().map {
      $1.asBetterParameter(index: $0)
    }

    // Если у исходного конструктора нет параметров или если все параметры анонимные,
    // нет смысла делать для него tryInit-версию.
    guard parameters.contains(where: \.isNamed) else { return nil }

    let maybeTry = isThrowingInitializer ? "try " : ""
    let maybeThrows = isThrowingInitializer ? "throws " : ""
    let maybeQuestionMark = isOptionalInitializer ? "?" : ""

    return """
    \(raw: function(
      keywords: [initializerAttributes, "static", "func"].filterNil(),
      name: "tryInit<SomeError: ComposableError>",
      parameters: parameters.map(\.asTryInitParameter),
      returns: "\(maybeThrows)-> Result<\(typeName)\(maybeQuestionMark), SomeError>",
      isCompact: false,
      body: """
      var errors: [String: SomeError] = [:]

      \(parameters
        .compactMap(\.innerName)
        .map { "\($0).asError.map { errors[\($0.quoted)] = $0 }" }
        .mkStringWithNewLine()
      )

      if let nonEmptyErrors = NonEmpty(rawValue: errors) {
        return .failure(.composed(from: nonEmptyErrors))
      }

      return \(maybeTry).success(
        .init(
      \("    ".prependingToLines(
        of: parameters.map(\.application).mkStringWithCommaAndNewLine()
      ))
        )
      )
      """
    )
  )
  """
  }
}


private extension BetterFunctionParameter {

  /// Формирует параметр для `tryInit`:
  /// именованный параметр оборачивает в Result<...>, а анонимный параметр оставляет без изменений.
  var asTryInitParameter: FunctionParameter {
    switch self {
    case .named(let parameter, _):
      // Именованные параметры оборачиваем в Result<...>.
      return parameter
        .with(typeModificator: { "Result<\($0), SomeError>" })
        .with(defaultValueModificator: { ".success(\($0))" })
    case .unnamed(let parameter, let index):
      // Анонимные параметры нет смысла оборачивать в Result<...>,
      // потому что их невозможно сохранить ни в какое поле класса или структуры.
      //
      // К анонимному параметру добавляем внутреннее имя,
      // чтобы его можно было в неизменном виде передать в оригинальный конструктор.
      return parameter.with(innerName: "_\(index)")
    }
  }

  /// Передача параметра из `tryInit` в оригинальный конструктор.
  ///
  /// Используется в самом конце `tryInit`,
  /// когда точно известно, что среди параметров нет ошибок, и можно формировать финальный результат.
  var application: String {
    switch self {
    case .named(let parameter, let innerName):
      // Именованный параметр имеет тип Result<...>.
      // Достаём значение из этого резалта и просим Свифт-линт не ругаться на `try!`.
      return parameter.initialization(
        withValue: "try! \(innerName).get() /* swiftlint:disable:this force_try */"
      )
    case .unnamed(let parameter, let index):
      // Анонимный параметр передаём как есть.
      return parameter.initialization(withValue: "_\(index)")
    }
  }

}
