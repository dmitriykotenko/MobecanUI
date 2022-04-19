// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


open class IconTextButton: DiverseButton {

  /// Внешние отступы, учитывающие ``spacing`` (расстояние между иконкой и текстом).
  ///
  /// Используйте это свойство для задания отступов вместо стандартного свойства ``contentEdgeInsets``.
  open var spacingAwareContentEdgeInsets: UIEdgeInsets {
    get { contentEdgeInsets.with(right: contentEdgeInsets.right - spacing) }
    set { contentEdgeInsets = newValue.with(right: newValue.right + spacing) }
  }
  
  private let spacing: CGFloat
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(spacing: CGFloat = 0) {
    self.spacing = spacing
    
    super.init(frame: .zero)

    contentHorizontalAlignment = .left
    
    titleEdgeInsets = .init(left: spacing, right: -spacing)
    
    spacingAwareContentEdgeInsets = .zero
  }
}
