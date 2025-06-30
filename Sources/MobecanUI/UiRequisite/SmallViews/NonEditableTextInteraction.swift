// Copyright © 2023 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


/// Способ взаимодействия с нередактируемым текстом,
/// показываемым внутри UITextView.
public struct NonEditableTextInteraction: Equatable, Hashable, Codable, Lensable {

  /// Можно ли выделить текст, чтобы потом скопировать его в буфер обмена.
  public var isTextSelectable: Bool

  /// Типы данных, которые автоматически распознаются внутри UITextView и на которые можно будет нажать.
  public var dataDetectorTypes: UIDataDetectorTypes

  public static let `default` = NonEditableTextInteraction(
    isTextSelectable: true,
    dataDetectorTypes: []
  )

  public static func selectableText(dataDetectorTypes: UIDataDetectorTypes) -> NonEditableTextInteraction {
    .init(
      isTextSelectable: true,
      dataDetectorTypes: dataDetectorTypes
    )
  }

  public static func nonSelectableText(dataDetectorTypes: UIDataDetectorTypes) -> NonEditableTextInteraction {
    .init(
      isTextSelectable: false,
      dataDetectorTypes: dataDetectorTypes
    )
  }

  public init(isTextSelectable: Bool,
              dataDetectorTypes: UIDataDetectorTypes) {
    self.isTextSelectable = isTextSelectable
    self.dataDetectorTypes = dataDetectorTypes
  }
}


extension UIDataDetectorTypes: @retroactive Hashable {}
extension UIDataDetectorTypes: @retroactive Codable {}
