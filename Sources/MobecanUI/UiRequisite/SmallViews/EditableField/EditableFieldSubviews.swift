//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public struct EditableFieldSubviews {
    
  public let valueEditor: UIView
  public let background: EditableFieldBackground
  public let titleLabel: UILabel
  public let hintLabel: UILabel
  public let errorLabel: UILabel

  public init(valueEditor: UIView,
              background: EditableFieldBackground,
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
