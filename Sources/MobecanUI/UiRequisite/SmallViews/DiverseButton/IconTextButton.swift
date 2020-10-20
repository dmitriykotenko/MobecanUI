//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


open class IconTextButton: DiverseButton {
  
  override open var contentEdgeInsets: UIEdgeInsets {
    set {
      super.contentEdgeInsets = newValue.with(right: newValue.right + spacing)
    }
    get {
      let superInsets = super.contentEdgeInsets
      return superInsets.with(right: superInsets.right - spacing)
    }
  }
  
  private let spacing: CGFloat
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(spacing: CGFloat = 0) {
    self.spacing = spacing
    
    super.init(frame: .zero)

    contentHorizontalAlignment = .left
    
    titleEdgeInsets = .init(left: spacing, right: -spacing)
    
    contentEdgeInsets = .zero
  }
}
