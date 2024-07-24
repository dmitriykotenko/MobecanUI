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
      tryInit(originalSignature: $0.signature, typeName: typeName)
    }

    if let someEnum = declaration.asEnum {
      tryInits += tryInitObject(for: someEnum).asSequence
    }

    return tryInits
  }

  private static func tryInitObject(for someEnum: Enum) -> DeclSyntax? {
    let nonTrivialCases = someEnum.nonTrivialCases

    guard nonTrivialCases.isNotEmpty else { return nil }

    let caseInits = nonTrivialCases.compactMap { tryInit(forCase: $0, ofEnum: someEnum) }

    let rawString = """
    enum tryInit {
    \(caseInits.map(\.trimmedDescription).mkStringWithNewParagraph())
    }
    """

    return "\(raw: rawString)"
  }

  private static func tryInit(forCase enumCase: EnumCase,
                              ofEnum someEnum: Enum) -> DeclSyntax? {
    guard enumCase.parameters.isNotEmpty else { return nil }

    return tryInit(
      originalSignature: .init(
        keywords: someEnum.visibilityModifiers + ["static", "func"],
        name: enumCase.name,
        genericParameters: [],
        parameters: enumCase.parameters.enumerated().map {
          $1.asInitializerParameter(defaultInnerName: "_\($0)")
        }
      ),
      typeName: someEnum.name
    )
  }

  private static func tryInit(originalSignature: FunctionSignature,
                              typeName: String) -> DeclSyntax? {
    let parameters = originalSignature.parameters.enumerated().map {
      $1.asBetterParameter(index: $0)
    }

    // Если у исходного конструктора нет параметров или если все параметры анонимные,
    // нет смысла делать для него tryInit-версию.
    guard parameters.contains(where: \.isNamed) else { return nil }

    return """
    \(raw: 
      function(
        signature: tryInitSignature(
          originalSignature: originalSignature,
          parameters: parameters,
          typeName: typeName
        ),
        body: tryInitBody(
          parameters: parameters,
          nameOfOriginalInit: originalSignature.name,
          maybeTry: originalSignature.isThrowing ? "try " : ""
        )
      )
    )
    """
  }

  private static func tryInitSignature(originalSignature: FunctionSignature,
                                       parameters: [BetterFunctionParameter],
                                       typeName: String) -> FunctionSignature {
    var signature = originalSignature

    if !signature.keywords.contains("func") { signature.name = "tryInit" }

    signature.keywords.appendNovelElements(from: ["static", "func"])
    signature.genericParameters += ["SomeError: ComposableError"]
    signature.parameters = parameters.map(\.asTryInitParameter)

    let maybeQuestionMark = originalSignature.name.hasSuffix("?") ? "?" : ""
    signature.returns = "-> Result<\(typeName)\(maybeQuestionMark), SomeError>"

    return signature
  }

  private static func tryInitBody(parameters: [BetterFunctionParameter],
                                  nameOfOriginalInit: String,
                                  maybeTry: String) -> String {
    """
      var errors: [String: SomeError] = [:]

      \(parameters
        .compactMap(\.innerName)
        .map { "\($0).asError.map { errors[\($0.quoted)] = $0 }" }
        .mkStringWithNewLine()
      )

      if let nonEmptyErrors = NonEmpty(rawValue: errors) {
        return .failure(.composed(from: nonEmptyErrors))
      }

      // swiftlint:disable force_try
      return \(maybeTry).success(
        .\(nameOfOriginalInit.dropLastWhile { $0 == "?" }.mkString())(
      \("    ".prependingToLines(
        of: parameters.map(\.application).mkStringWithCommaAndNewLine()
      ))
        )
      )
      // swiftlint:enable force_try
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
      // Именованный параметр имеет тип Result<...>. Достаём значение из этого резалта.
      return parameter.initialization(
        withValue: "try! \(innerName).get()"
      )
    case .unnamed(let parameter, let index):
      // Анонимный параметр передаём как есть.
      return parameter.initialization(withValue: "_\(index)")
    }
  }
}
