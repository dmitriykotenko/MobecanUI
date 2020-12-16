//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public extension SimpleTableViewSticker {

  var textSettings: TextSettings {
    get {
      .init(
        initLabel: initLabel,
        labelInsets: labelInsets,
        textFromHeader: textFromHeader
      )
    }

    set {
      initLabel = newValue.initLabel
      labelInsets = newValue.labelInsets
      textFromHeader = newValue.textFromHeader
    }
  }

  struct TextSettings: Lensable {

    public var initLabel: () -> UILabel
    public var labelInsets: UIEdgeInsets
    public var textFromHeader: (SimpleTableViewHeader) -> String

    public init(initLabel: @escaping () -> UILabel = { UILabel() },
                labelInsets: UIEdgeInsets = .zero,
                textFromHeader: @escaping (SimpleTableViewHeader) -> String = Self.defaultTextFromHeader) {
      self.initLabel = initLabel
      self.labelInsets = labelInsets
      self.textFromHeader = textFromHeader
    }

    public static let defaultTextSettings = TextSettings()

    public static let defaultTextFromHeader: (SimpleTableViewHeader) -> String = {
      switch $0 {
      case .loadingInProgress:
        return "Идёт загрузка..."
      case .nothingFound:
        return "Ничего не найдено"
      case .error:
        return "Ошибка при загрузке данных"
      case .string(let string):
        return string ?? ""
      }
    }
  }
}
