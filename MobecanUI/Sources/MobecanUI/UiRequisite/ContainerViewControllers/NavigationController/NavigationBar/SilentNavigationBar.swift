//  Copyright © 2020 Mobecan. All rights reserved.


import RxCocoa
import RxSwift
import SnapKit
import UIKit


public class SilentNavigationBar: NavigationBar {
  
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
      $0.top.bottom.leading.equalToSuperview()
    }
    
    rightButton.snp.makeConstraints {
      $0.top.bottom.trailing.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.bottom.centerX.equalToSuperview()
      $0.leading.greaterThanOrEqualTo(leftButton).inset(spacing)
      $0.trailing.lessThanOrEqualTo(rightButton).inset(spacing)
    }

    _ = self.height(height)
  }
  
  override public var affectsSafeArea: Bool { false }
}
