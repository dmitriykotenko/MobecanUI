// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public struct EditableFieldSubviews {

  /// Вьюшка, с помощью которой пользователь редактирует значение поля
  /// (например, UITextField или UITextView).
  public let valueEditor: UIView

  /// Вьюшка-фон.
  public let background: EditableFieldBackgroundProtocol

  /// Лэйбл с названием поля.
  public let titleLabel: UILabel

  /// Лэйбл с подсказкой к полю.
  public let hintLabel: UILabel

  /// Лэйбл с ошибкой валидации.
  public let errorLabel: UILabel

  /// Необязательная часть ``EditableField``, которая становится firstResponder-ом в начале редактирования поля.
  ///
  /// Обычно это UITextField или UITextView.
  ///
  /// Явное указание этой вьюшки нужно для более быстрой работы ``EditableField``.
  public let focusableView: UIView?

  var all: [UIView] {
    [
      valueEditor,
      background,
      titleLabel,
      hintLabel,
      errorLabel
    ]
  }

  public init(valueEditor: UIView,
              background: EditableFieldBackgroundProtocol,
              titleLabel: UILabel,
              hintLabel: UILabel,
              errorLabel: UILabel,
              focusableView: UIView?) {
    self.valueEditor = valueEditor
    self.background = background
    self.titleLabel = titleLabel
    self.hintLabel = hintLabel
    self.errorLabel = errorLabel
    self.focusableView = focusableView
  }
}
