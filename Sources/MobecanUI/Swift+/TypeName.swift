// Copyright © 2024 Mobecan. All rights reserved.


/// Текстовое представление типа данных в Свифте.
///
/// Позволяет получить тип данных по его названию с помощью системной функции `_typeByName()`, например:
/// ```
/// let stringType = _typeByName("Swift.String") as! String.self
/// let intType = _typeByName("Swift.Int") as! Int.self
/// let urlType = _typeByName("10Foundation3URLV") as! URL.self
/// ```
///
/// - Warning: Функция `_typeByName()` работает нестабильно.
/// Надёжнее всего она работает, если в качестве аргумента использовать `TypeName.mangled`.
/// Но надёжная работа не гарантируется в будущих версиях Свифта.
public struct TypeName: Equatable, Hashable, Codable {

  /// Имя класса без учёта нэймспэйсов. Например: "String".
  ///
  /// - Warning: Если нужно восстановить тип по его названию с помощью функции `_typeByName()`,
  /// используйте `TypeName.mangled`,
  /// потому что при использовании `TypeName.nonQualified`
  /// функция `_typeByName()` часто возвращает `nil`.
  public var nonQualified: String

  /// Имя класса с учётом нэймспэйсов.
  ///
  /// Например, если у нас есть Свифт-пакет `MyPackage`,
  /// а внутри него объявлена вот такая структура...
  /// ```
  /// struct MyStruct {
  ///   struct MyChildStruct {}
  ///   var child: MyChildStruct
  /// }
  /// ```
  /// ... то полным именем `MyChildStruct` будет `"MyPackage.MyStruct.MyChildStruct"`.
  ///
  /// - Warning: Если нужно восстановить тип по его названию с помощью функции `_typeByName()`,
  /// используйте `TypeName.mangled`,
  /// потому что при использовании `TypeName.qualified`
  /// функция `_typeByName()` часто возвращает `nil`.
  public var qualified: String

  /// Имя класса с учётом нэймспэйса, закодированное в специальную буквенно-цифровую форму.
  ///
  /// Его можно получить с помощью системной функции `_mangledTypeName()`:
  /// ```
  /// let mangledName = _mangledTypeName(URL.self)
  /// mangledName == "10Foundation3URLV"
  /// ```
  ///
  /// Изначально эта спец-кодировка предназначалась для того,
  /// чтобы отличать в рантайме функции с одинаковой сигнатурой.
  ///
  /// Но есть побочный эффект:
  /// функция `_typeByName()`, восстанавливающая тип по его названию,
  ///  надёжнее всего работает именно с такой кодировкой.
  ///
  ///  - Warning: Для некоторых типов данных равно `nil`.
  ///  В таких случаях пробуйте использовать `TypeName.qualified` или `TypeName.nonQualified`.
  ///  - Warning: Всегда равно `nil` в iOS 13 и в более младших версиях.
  public var mangled: String?

  /// Пытается восстановить тип данных по названию.
  ///
  /// Если ``mangled != nil``, возвращает `_typeByName(mangled)`.
  /// Если ``mangled == nil``, возвращает `_typeByName(qualified)`.
  ///
  /// - Warning: Функция `_typeByName()` работает нестабильно.
  /// Надёжнее всего она работает, если в качестве аргумента использовать `TypeName.mangled`.
  /// Но надёжная работа не гарантируется в будущих версиях Свифта.
  ///
  /// - Warning: iOS 13 и более младшие версии не поддерживают ``TypeName.mangled``,
  /// поэтому велик шанс, что ``reconstructedType == nil``.
  ///
  /// - Returns: Воссозданный тип данных или `nil`, если тип данных не удалось воссоздать.
  public var reconstructedType: Any.Type? {
    _typeByName(mangled ?? qualified)
  }

  public init(type: Any.Type) {
    if #available(iOS 14.0, *) {
      self.init(
        nonQualified: _typeName(type, qualified: false),
        qualified: _typeName(type, qualified: true),
        mangled: _mangledTypeName(type)
      )
    } else {
      self.init(
        nonQualified: _typeName(type, qualified: false),
        qualified: _typeName(type, qualified: true),
        mangled: nil
      )
    }
  }

  public init(nonQualified: String,
              qualified: String,
              mangled: String?) {
    self.nonQualified = nonQualified
    self.qualified = qualified
    self.mangled = mangled
  }
}
