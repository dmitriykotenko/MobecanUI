//  Copyright © 2019 Mobecan. All rights reserved.

import UIKit


/// Button with enlarged line spacing.
public class MultilineTextButton: DiverseButton {
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init() { super.init(frame: .zero) }
  
  override public func setTitle(_ title: String?,
                                for state: UIControl.State) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = (titleLabel?.font.lineHeight ?? 0) * 0.5

    setAttributedTitle(
      title.map { NSAttributedString(string: $0, attributes: [.paragraphStyle: paragraphStyle]) },
      for: state
    )
  }
}
