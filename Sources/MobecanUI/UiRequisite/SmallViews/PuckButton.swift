// Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import SwiftDateTime
import UIKit


public class PuckButton: LayoutableControl {
  
  public var tap: Observable<Void> { rx.tapGesture().when(.recognized).mapToVoid() }

  private let iconView: UIImageView
  private let backgroundView: UIView
  
  private let tapInsets: UIEdgeInsets

  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(iconView: UIImageView,
              backgroundColor: UIColor,
              puckRadius: CGFloat,
              shadow: Shadow,
              tapInsets: UIEdgeInsets) {
    self.iconView = iconView
    
    self.backgroundView = UIView.circle(radius: puckRadius)
      .backgroundColor(backgroundColor)
      .clipsToBounds(false)
      .withShadow(shadow)
    
    self.tapInsets = tapInsets
    
    super.init()

    layout = InsetLayout<UIView>.fromSingleSubview(
      .zstack([backgroundView, iconView])
    )

    highlightOnTaps(disposeBag: disposeBag)
  }
}
