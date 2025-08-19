// Copyright © 2024 Mobecan. All rights reserved.

import Foundation


@freestanding(expression)
@available(swift 5.9)
public macro URL(_ string: String) -> URL = #externalMacro(
  module: "MobecanUIMacros",
  type: "UrlMacro"
)


/// Добавляет дефолтный конструктор,
/// заполняющий все поля класса или структуры и имеющий такую же видимость,
/// как и сам класс или сама структура.
@attached(member, names: named(init))
@available(swift 5.9)
public macro MemberwiseInit() = #externalMacro(
  module: "MobecanUIMacros",
  type: "MemberwiseInitMacro2"
)


/// Добавляет дефолтный конструктор,
/// заполняющий все поля класса или структуры и имеющий такую же видимость,
/// как и сам класс или сама структура.
@attached(member, names: named(init))
@available(swift 5.9)
public macro MemberwiseInit2() = #externalMacro(
  module: "MobecanUIMacros",
  type: "MemberwiseInitMacro"
)


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
@attached(member, names: named(tryInit))
@available(swift 5.9)
public macro TryInit() = #externalMacro(
  module: "MobecanUIMacros",
  type: "TryInitMacro"
)


@attached(extension, conformances: EmptyCodingKeysReflector, SimpleCodingKeysReflector)
@attached(member, names: named(codingKeyTypes))
@available(swift 5.9)
public macro DerivesCodingKeysReflector() = #externalMacro(
  module: "MobecanUIMacros", 
  type: "CodingKeysReflectorMacro"
)


@attached(extension, conformances: AutoGeneratable, names: arbitrary)
@attached(member, names: arbitrary)
@available(swift 5.9)
public macro DerivesAutoGeneratable() = #externalMacro(
  module: "MobecanUIMacros",
  type: "AutoGeneratableMacro"
)
