//  Copyright © 2020 Mobecan. All rights reserved.

import SnapKit
import UIKit


public class TallNavigationBar: NavigationBar {
  
  public var buttonsHeight: CGFloat = 0
  public var verticalSpacing: CGFloat = 0

  override public func setupLayout(subviews: NavigationBar.Subviews,
                                   rightViewContainer: UIView,
                                   height: CGFloat? = nil,
                                   spacing: CGFloat) {
    super.setupLayout(
      subviews: subviews,
      rightViewContainer: rightViewContainer,
      height: height,
      spacing: spacing
    )
    
    subviews.leftButton.snp.makeConstraints {
      $0.top.leading.equalToSuperview()
      $0.height.equalTo(buttonsHeight)
    }
    
    rightViewContainer.snp.makeConstraints {
      $0.top.trailing.equalToSuperview()
      $0.height.equalTo(buttonsHeight)
    }

    let titleInset = subviews.leftButton.contentEdgeInsets.left
    
    subviews.titleView.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.leading.equalToSuperview().inset(titleInset)
      $0.trailing.lessThanOrEqualToSuperview().inset(titleInset)
      
      $0.top.equalTo(subviews.leftButton.snp.bottom).offset(verticalSpacing)
    }
  }
}
