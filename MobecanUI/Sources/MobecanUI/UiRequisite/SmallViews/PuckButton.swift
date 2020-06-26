//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime
import UIKit


public class PuckButton: UIControl {
  
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
    
    super.init(frame: .zero)

    addSubviews()
    highlightOnTaps(disposeBag: disposeBag)
  }
  
  private func addSubviews() {
    addSingleSubview(
      .zstack(
        [backgroundView, iconView]
      )
    )
  }
}
