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
      overallInsets: .zero,
      valueEditorInsets: .init(amount: 20),
      verticalSpacing: 10
    )
  }
}


public class EditableFieldVerticalLayout: EditableFieldLayout {

  /// Insets between field's edges and its subviews.
  public var overallInsets: UIEdgeInsets

  /// Insets between value editor and background view.
  public var valueEditorInsets: UIEdgeInsets

  /// Spacing between field's rows.
  ///
  /// 1. First row is titleLabel.
  /// 2. Second row is backgroundView + valueEditor.
  /// 3. Third row is hintLabel.
  /// 4. Fourth row is errorLabel.
  public var verticalSpacing: CGFloat
  
  public init(overallInsets: UIEdgeInsets,
              valueEditorInsets: UIEdgeInsets,
              verticalSpacing: CGFloat) {
    self.overallInsets = overallInsets
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
      ],
      insets: overallInsets
    )
  }
}
