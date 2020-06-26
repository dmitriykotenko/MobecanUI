//  Copyright © 2019 Mobecan. All rights reserved.

import UIKit


/// Button with enlarged line spacing.
public class IconTextButton: DiverseButton {
  
  override public var contentEdgeInsets: UIEdgeInsets {
    set {
      super.contentEdgeInsets = newValue.with(right: newValue.right + innerPadding)
    }
    get {
      let superInsets = super.contentEdgeInsets
      return superInsets.with(right: superInsets.right - innerPadding)
    }
  }
  
  private let innerPadding: CGFloat
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(innerPadding: CGFloat = 0) {
    self.innerPadding = innerPadding
    
    super.init(frame: .zero)

    contentHorizontalAlignment = .left
    
    titleEdgeInsets = .init(left: innerPadding, right: -innerPadding)
    
    contentEdgeInsets = .zero
  }
}
