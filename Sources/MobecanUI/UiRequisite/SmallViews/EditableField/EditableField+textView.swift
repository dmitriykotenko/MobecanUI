// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public extension EditableField where RawValue == String? {
  
  /// Создаёт ``EditableField`` на основе ``UITextView``.
  /// - Parameters:
  ///   - textView: Текст-вью, на основе которого надо создать редактируемое поле.
  ///   - backgroundView: Фон для ``EditableField``.
  ///   - initSubviews: Добавляет к `textView` и `backgroundView` недостающие составные части ``EditableField``.
  ///   - layout: Вёрстка.
  ///   - validator: Валидатор строки, лежащей в текст-вью.
  convenience init(textView: UITextView,
                   backgroundView: EditableFieldBackgroundProtocol,
                   initSubviews: @escaping (UITextView, EditableFieldBackgroundProtocol) -> EditableFieldSubviews,
                   layout: EditableFieldLayout,
                   validator: @escaping (String?) -> SoftResult<ValidatedValue, ValidationError>) {
    self.init(
      subviews: initSubviews(textView, backgroundView),
      layout: layout,
      rawValueGetter: textView.rx.text.asObservable(),
      rawValueSetter: textView.rx.text.asObserver(),
      validator: validator
    )
  }
}


public extension EditableField where RawValue == String?, ValidatedValue == String? {
  
  /// Создаёт ``EditableField`` на основе ``UITextView``.
  /// - Parameters:
  ///   - textView: Текст-вью, на основе которого надо создать редактируемое поле.
  ///   - backgroundView: Фон для ``EditableField``.
  ///   - initSubviews: Добавляет к `textView` и `backgroundView` недостающие составные части ``EditableField``.
  ///   - layout: Вёрстка.
  ///   - validator: Валидатор строки, лежащей в текст-вью.
  convenience init(textView: UITextView,
                   backgroundView: EditableFieldBackgroundProtocol,
                   initSubviews: @escaping (UITextView, EditableFieldBackgroundProtocol) -> EditableFieldSubviews,
                   layout: EditableFieldLayout,
                   validator: @escaping (RawValue) -> SoftResult<ValidatedValue, ValidationError> = { .success($0) }) {
    self.init(
      subviews: initSubviews(textView, backgroundView),
      layout: layout,
      rawValueGetter: textView.rx.text.asObservable(),
      rawValueSetter: textView.rx.text.asObserver(),
      validator: validator
    )
  }
}
