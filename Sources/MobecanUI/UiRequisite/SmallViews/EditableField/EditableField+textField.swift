// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public extension EditableField where RawValue == String? {

  /// Создаёт ``EditableField`` на основе ``UITextField``.
  /// - Parameters:
  ///   - textField: Текст-филд, на основе которого надо создать редактируемое поле.
  ///   - backgroundView: Фон для ``EditableField``.
  ///   - initSubviews: Добавляет к `textField` и `backgroundView` недостающие составные части ``EditableField``.
  ///   - layout: Вёрстка.
  ///   - validator: Валидатор строки, лежащей в текст-филде.
  convenience init(textField: UITextField,
                   backgroundView: EditableFieldBackgroundProtocol,
                   initSubviews: @escaping (UITextField, EditableFieldBackgroundProtocol) -> EditableFieldSubviews,
                   layout: EditableFieldLayout,
                   validator: @escaping (RawValue) -> SoftResult<ValidatedValue, ValidationError>) {
    self.init(
      subviews: initSubviews(textField, backgroundView),
      layout: layout,
      rawValueGetter: textField.rx.text.asObservable(),
      rawValueSetter: textField.rx.text.asObserver(),
      validator: validator
    )
  }
}


public extension EditableField where RawValue == String?, ValidatedValue == String? {

  /// Создаёт ``EditableField`` на основе ``UITextField``.
  /// - Parameters:
  ///   - textField: Текст-филд, на основе которого надо создать редактируемое поле.
  ///   - backgroundView: Фон для ``EditableField``.
  ///   - initSubviews: Добавляет к `textField` и `backgroundView` недостающие составные части ``EditableField``.
  ///   - layout: Вёрстка.
  ///   - validator: Валидатор строки, лежащей в текст-филде.
  convenience init(textField: UITextField,
                   backgroundView: EditableFieldBackgroundProtocol,
                   initSubviews: @escaping (UITextField, EditableFieldBackgroundProtocol) -> EditableFieldSubviews,
                   layout: EditableFieldLayout,
                   validator: @escaping (RawValue) -> SoftResult<ValidatedValue, ValidationError> = { .success($0) }) {
    self.init(
      subviews: initSubviews(textField, backgroundView),
      layout: layout,
      rawValueGetter: textField.rx.text.asObservable(),
      rawValueSetter: textField.rx.text.asObserver(),
      validator: validator
    )
  }
}
