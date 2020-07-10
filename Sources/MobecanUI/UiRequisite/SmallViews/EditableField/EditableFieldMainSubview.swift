// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public protocol EditableFieldLayout {

  func mainSubview(_ subviews: EditableFieldSubviews) -> UIView
}


public extension EditableFieldLayout {
  
  static var vertical: EditableFieldLayout {
    EditableFieldVerticalLayout(
      valueEditorInsets: .init(amount: 20),
      verticalSpacing: 10
    )
  }
}


public class EditableFieldVerticalLayout: EditableFieldLayout {
  
  public let valueEditorInsets: UIEdgeInsets
  public let verticalSpacing: CGFloat
  
  public init(valueEditorInsets: UIEdgeInsets,
              verticalSpacing: CGFloat) {
    self.valueEditorInsets = valueEditorInsets
    self.verticalSpacing = verticalSpacing
  }
  
  open func mainSubview(_ subviews: EditableFieldSubviews) -> UIView {
    .vstack(
      alignment: .fill,
      spacing: verticalSpacing,
      [
        subviews.titleLabel.fitToContent(axis: [.vertical]),
        .zstack([
          subviews.background,
          subviews.valueEditor.withInsets(valueEditorInsets),
        ]),
        subviews.hintLabel.fitToContent(axis: [.vertical]),
        subviews.errorLabel.fitToContent(axis: [.vertical])
      ]
    )
  }
}
