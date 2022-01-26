// Copyright © 2020 Mobecan. All rights reserved.


import RxCocoa
import RxSwift
import SnapKit
import UIKit


public class SilentNavigationBar: NavigationBar {

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
      $0.top.bottom.leading.equalToSuperview()
    }
    
    rightViewContainer.snp.makeConstraints {
      $0.top.bottom.trailing.equalToSuperview()
    }
    
    subviews.titleView.snp.makeConstraints {
      $0.top.bottom.centerX.equalToSuperview()
      $0.leading.greaterThanOrEqualTo(subviews.leftButton).inset(spacing)
      $0.trailing.lessThanOrEqualTo(rightViewContainer).inset(spacing)
    }

    height.map { _ = self.autolayoutHeight($0) }
  }
  
  override public var affectsSafeArea: Bool { false }
}
