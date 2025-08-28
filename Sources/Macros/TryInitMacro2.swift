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
public struct TryInitMacro2 {}


extension TryInitMacro2: MemberMacro, MobecanDeclaration {

  public static func expansion(of node: AttributeSyntax,
                               providingMembersOf declaration: some DeclGroupSyntax,
                               conformingTo protocols: [TypeSyntax],
                               in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    try tryInits(declaration: declaration)
  }

  private static func tryInits(declaration: some DeclGroupSyntax) throws -> [DeclSyntax] {
//    guard let typeName = declaration.asNamedDeclaration?.name.text
//    else { return [] }
    guard let typeName = declaration.asNamedDeclaration?.name
    else { return [] }

    var tryInits = declaration
      .initializersIncludingMacroGenerated2
      .compactMap { tryInit(originalInitializerDecl: $0, typeName: typeName) }

    if let someEnum = declaration.as(EnumDeclSyntax.self) {
      tryInits += tryInitObject(enumDecl: someEnum).asSequence
    }

//    if let someEnum = declaration.asEnum {
//      tryInits += tryInitObject(for: someEnum, enumDecl: declaration).asSequence
//    }

    return tryInits
  }

  private static func tryInitObject(enumDecl: EnumDeclSyntax) -> DeclSyntax? {
    let nonTrivialCases = enumDecl.memberBlock.members
      .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
      .filter { $0.elements.compactMap { $0.parameterClause?.parameters}.isNotEmpty }

    guard nonTrivialCases.isNotEmpty else { return nil }

    return DeclSyntax(
      _enum("tryInit", modifiers: enumDecl.visibilityPrefix3) {
        for nonTrivialCase in nonTrivialCases {
          tryInit(
            enumCaseDecl: nonTrivialCase,
            enumCaseElement: nonTrivialCase.elements.first!,
            enumDecl: enumDecl
          )!
        }
      }
    )
  }

  private static func tryInit(enumCaseDecl: EnumCaseDeclSyntax,
                              enumCaseElement: EnumCaseElementSyntax,
                              enumDecl: EnumDeclSyntax) -> DeclSyntax? {
    guard enumCaseElement.parameterClause?.parameters.isNotEmpty == true else { return nil }

    return tryInit(
      originalFunctionDecl: .init(
        leadingTrivia: enumCaseDecl.leadingTrivia,
        attributes: enumCaseDecl.attributes,
        modifiers: enumDecl.modifiers,
        name: enumCaseElement.name,
        genericParameterClause: nil,
        signature: .init(
          parameterClause: .init(
            parameters: .init(
              enumCaseElement.parameterClause?.parameters.enumerated().map { index, parameter in
                parameter.asFunctionParameter(index: index)
              } ?? []
            )
          ),
          returnClause: ReturnClauseSyntax(
            type: _t(enumDecl.name)
          )
        ),
        genericWhereClause: nil,
        body: nil,
        trailingTrivia: enumCaseDecl.trailingTrivia
      ),
      typeName: enumDecl.name
    )

//    return tryInit(
//      originalSignature: .init(
//        keywords: someEnum.visibilityModifiers.map(\.rawValue) + ["static", "func"],
//        name: enumCase.name,
//        genericParameters: [],
//        parameters: enumCase.parameters.enumerated().map {
//          $1.asInitializerParameter(defaultInnerName: "_\($0)")
//        }
//      ),
//      typeName: someEnum.name
//    )
  }

  private static func tryInit(originalInitializerDecl: InitializerDeclSyntax,
                              typeName: TokenSyntax) -> DeclSyntax? {
    let parameters = originalInitializerDecl.signature.parameterClause.parameters

    // Если у исходного конструктора нет параметров или если все параметры анонимные,
    // нет смысла делать для него tryInit-версию.
    guard parameters.contains(where: \.isNamed) else { return nil }

    return DeclSyntax(
      _func(
        "tryInit",
        modifiers:
          originalInitializerDecl.modifiers
          .filter { $0.name.text != "required" }
          + [m.static],
        generics: _gen.params(
          (originalInitializerDecl.genericParameterClause?.parameters ?? [])
          + [
            _gen.param("SomeError", inherits: _t("ComposableError"))
          ]),
        params: _funcParams {
          for (index, p) in parameters.enumerated() {
            p.asTryInitParameter(index: index, error: "SomeError")
          }
        },
        returns: _t(
          _result:
            _t(typeName).optIf(originalInitializerDecl.isOptional),
            _t("SomeError")
        ),
        whereClause: originalInitializerDecl.genericWhereClause,
        body: {
          //      var errors: [String: SomeError] = [:]
          _var(
            "errors",
            _t(_dictionary: _t("String"), _t("SomeError")),
            ^=_emptyDictionaryLiteral
          )

          //        \(parameters
          //          .compactMap(\.innerName)
          //          .map { "\($0).asError.map { errors[\($0.quoted)] = $0 }" }
          //          .mkStringWithNewLine()
          //        )
          for innerName in parameters.compactMap(\.innerName) {
            _ref(innerName)
              .dot("asError")
              .dot("map").call(trailingClosure: _closure {
                _ref("errors").subscript(_string(innerName.text)) ^== _ref("$0")
              })
          }

          //      if let nonEmptyErrors = NonEmpty(rawValue: errors) {
          //        return .failure(.composed(from: nonEmptyErrors))
          //      }
          _ifLet(
            "nonEmptyErrors",
            _e(_t("NonEmpty")).call(
              "rawValue" <- _ref("errors")
            )
          ) {
            _return(
              _dot("failure").call(_dot("composed").call(
                "from" <- _ref("nonEmptyErrors"))
              )
            )
          }

          //        // swiftlint:disable force_try
          //        return \(maybeTry).success(
          //          .\(nameOfOriginalInit.dropLastWhile { $0 == "?" }.mkString())(
          //            \("    ".prependingToLines(
          //              of: parameters.map(\.application).mkStringWithCommaAndNewLine()
          //            ))
          //          )
          //        )
          //        // swiftlint:enable force_try
          _return(
            _dot("success").call(
              _dot(_token_init).call(
                parameters.enumerated().map { index, param in
                  if let name = param.innerName {
                    param.outerName <- _ref(name).dot("get").call()
                  } else {
                    <--_ref("_\(index)")
                  }
                }
              )
            )
            .asForceTry
          )
        }
      )
    )
  }

  private static func tryInit(originalFunctionDecl: FunctionDeclSyntax,
                              typeName: TokenSyntax) -> DeclSyntax? {
    let parameters = originalFunctionDecl.signature.parameterClause.parameters

    // Если у исходного конструктора нет параметров или если все параметры анонимные,
    // нет смысла делать для него tryInit-версию.
    guard parameters.contains(where: \.isNamed) else { return nil }

    return DeclSyntax(
      _func(
        originalFunctionDecl.name,
        modifiers:
          originalFunctionDecl.modifiers
            .filter { $0.name.text != "required" }
            + [m.static],
        generics: _gen.params(
          (originalFunctionDecl.genericParameterClause?.parameters ?? [])
          + [
            _gen.param("SomeError", inherits: _t("ComposableError"))
          ]),
        params: _funcParams {
          for (index, p) in parameters.enumerated() {
            p.asTryInitParameter(index: index, error: "SomeError")
          }
        },
        returns: _t(
          _result:
            _t(typeName).optIf(originalFunctionDecl.doesReturnOptional),
            _t("SomeError")
        ),
        whereClause: originalFunctionDecl.genericWhereClause,
        body: {
          //      var errors: [String: SomeError] = [:]
          _var(
            "errors",
            _t(_dictionary: _t("String"), _t("SomeError")),
            ^=_emptyDictionaryLiteral
          )

          //        \(parameters
          //          .compactMap(\.innerName)
          //          .map { "\($0).asError.map { errors[\($0.quoted)] = $0 }" }
          //          .mkStringWithNewLine()
          //        )
          for innerName in parameters.compactMap(\.innerName) {
            _ref(innerName)
              .dot("asError")
              .dot("map").call(trailingClosure: _closure {
                _ref("errors").subscript(_string(innerName.text)) ^== _ref("$0")
              })
          }

          //      if let nonEmptyErrors = NonEmpty(rawValue: errors) {
          //        return .failure(.composed(from: nonEmptyErrors))
          //      }
          _ifLet(
            "nonEmptyErrors",
            _e(_t("NonEmpty")).call("rawValue" <- _ref("errors"))
          ) {
            _return(
              _dot("failure").call(_dot("composed").call("from" <- _ref("nonEmptyErrors")))
            )
          }

          //        // swiftlint:disable force_try
          //        return \(maybeTry).success(
          //          .\(nameOfOriginalInit.dropLastWhile { $0 == "?" }.mkString())(
          //            \("    ".prependingToLines(
          //              of: parameters.map(\.application).mkStringWithCommaAndNewLine()
          //            ))
          //          )
          //        )
          //        // swiftlint:enable force_try
          _return(
            _dot("success").call(
              _dot(originalFunctionDecl.name).call(
                parameters.enumerated().map { index, param in
                  if let name = param.innerName {
                    param.outerName <- _ref(name).dot("get").call()
                  } else {
                    <--_ref("_\(index)")
                  }
                }
              )
            )
            .asForceTry
          )
        }
      )
    )
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
        .withNonEnscapingTypeIsNecessary
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


extension FunctionDeclSyntax {

  var isThrowing: Bool {
    signature.effectSpecifiers?.throwsClause != nil
  }
}


extension FunctionParameterSyntax {

  var isNamed: Bool {
    !isUnnamed
  }

  var isUnnamed: Bool {
    firstName.tokenKind == .wildcard
    && (secondName?.tokenKind == .wildcard || secondName == nil)
  }

  var outerName: TokenSyntax? {
    switch firstName.tokenKind {
    case .wildcard: nil
    default: firstName
    }
  }

  var innerName: TokenSyntax? {
    switch secondName?.tokenKind {
    case .wildcard: nil
    default: secondName ?? outerName
    }
  }
}


extension InitializerDeclSyntax {

  var doesReturnOptional: Bool {
    optionalMark?.tokenKind == .postfixQuestionMark
  }
}


extension FunctionDeclSyntax {

  var doesReturnOptional: Bool {
    signature.returnClause?.type.is(OptionalTypeSyntax.self) == true
  }
}


extension EnumCaseParameterSyntax {

  func asFunctionParameter(index: Int) -> FunctionParameterSyntax {
    .init(
      firstName: firstName ?? .wildcardToken(),
      secondName: firstName == nil ? _token("_\(index)") : nil,
      type: type,
      defaultValue: defaultValue,
      trailingComma: .commaToken()
    )
  }
}
