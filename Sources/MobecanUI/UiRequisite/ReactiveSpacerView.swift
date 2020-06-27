//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


public class ReactiveSpacerView: UIView {
  
  private weak var targetView: UIView?
  private let axis: [NSLayoutConstraint.Axis]
  private let insets: UIEdgeInsets

  private let framesListener: FramesListener

  private var widthConstraint: Constraint?
  private var heightConstraint: Constraint?

  private let disposeBag = DisposeBag()

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(targetView: UIView,
              axis: [NSLayoutConstraint.Axis],
              insets: UIEdgeInsets) {
    self.targetView = targetView
    self.axis = axis
    self.insets = insets
    
    self.framesListener = FramesListener(views: [targetView])
    
    super.init(frame: .zero)

    setupInitialSize()
    setupSizeUpdating()

  }
  
  private func setupInitialSize() {
    snp.makeConstraints {
      widthConstraint = $0.width.equalTo(0).priority(.minimum).constraint
      heightConstraint = $0.height.equalTo(0).priority(.minimum).constraint
    }
  }
  
  private func setupSizeUpdating() {
    framesListener.framesChanged
      .subscribe(onNext: { [weak self] in self?.updateSize() })
      .disposed(by: disposeBag)
  }

  private func updateSize() {
    targetView.map {
      if axis.contains(.horizontal) {
        widthConstraint?.update(priority: .required)
        widthConstraint?.update(offset: $0.frame.width + insets.left + insets.right)
      }
      if axis.contains(.vertical) {
        heightConstraint?.update(priority: .required)
        heightConstraint?.update(offset: $0.frame.height + insets.top + insets.bottom)
      }
    }
  }
}
