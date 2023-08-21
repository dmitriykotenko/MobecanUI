// Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import UIKit


/// Текст-вью с бо̀льшими возможностями для настройки, чем у обычного UITextView.
open class DiverseTextView: SizableTextView {

  public var nonEditableTextInteraction: NonEditableTextInteraction = .default {
    didSet { nonEditableTextInteractionChanged() }
  }

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public convenience init() { self.init(frame: .zero) }

  override public init(frame: CGRect,
                       textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
  }

  private func nonEditableTextInteractionChanged() {
    dataDetectorTypes = nonEditableTextInteraction.dataDetectorTypes
  }

  override open var canBecomeFirstResponder: Bool {
    isEditable || nonEditableTextInteraction.isTextSelectable
  }

  @discardableResult
  open func nonEditableTextInteraction(_ nonEditableTextInteraction: NonEditableTextInteraction) -> Self {
    self.nonEditableTextInteraction = nonEditableTextInteraction
    return self
  }
}
