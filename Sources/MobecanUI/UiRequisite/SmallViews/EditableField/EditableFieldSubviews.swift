//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public struct EditableFieldSubviews {
    
  public let valueEditor: UIView
  public let background: EditableFieldBackgroundProtocol
  public let titleLabel: UILabel
  public let hintLabel: UILabel
  public let errorLabel: UILabel

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
              errorLabel: UILabel) {
    self.valueEditor = valueEditor
    self.background = background
    self.titleLabel = titleLabel
    self.hintLabel = hintLabel
    self.errorLabel = errorLabel
  }
}
