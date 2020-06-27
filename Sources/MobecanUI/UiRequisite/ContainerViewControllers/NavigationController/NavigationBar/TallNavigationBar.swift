//  Copyright © 2020 Mobecan. All rights reserved.

import SnapKit
import UIKit


public class TallNavigationBar: NavigationBar {
  
  public var buttonsHeight: CGFloat = 0
  public var verticalSpacing: CGFloat = 0

  override public func setupLayout(height: CGFloat,
                                   leftButton: UIButton,
                                   rightButton: UIButton,
                                   titleLabel: UILabel,
                                   spacing: CGFloat) {
    super.setupLayout(
      height: height,
      leftButton: leftButton,
      rightButton: rightButton,
      titleLabel: titleLabel,
      spacing: spacing
    )
    
    leftButton.snp.makeConstraints {
      $0.top.leading.equalToSuperview()
      $0.height.equalTo(buttonsHeight)
    }
    
    rightButton.snp.makeConstraints {
      $0.top.trailing.equalToSuperview()
      $0.height.equalTo(buttonsHeight)
    }
    
    titleLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.leading.equalToSuperview().inset(leftButton.contentEdgeInsets.left)
      $0.trailing.lessThanOrEqualToSuperview().inset(rightButton.contentEdgeInsets.right)
      
      $0.top.equalTo(leftButton.snp.bottom).offset(verticalSpacing)
    }
  }
}
