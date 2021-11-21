//  Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit


public class ReactiveSpacerView: LayoutableView {
  
  private weak var targetView: UIView?
  private let axis: [NSLayoutConstraint.Axis]
  private let insets: UIEdgeInsets

  private let framesListener: FramesListener

  private let disposeBag = DisposeBag()

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(targetView: UIView,
              axis: [NSLayoutConstraint.Axis],
              insets: UIEdgeInsets) {
    self.targetView = targetView
    self.axis = axis
    self.insets = insets
    
    self.framesListener = FramesListener(views: [targetView])
    
    super.init()

    self.layout = EmptyLayout().with(size: .zero)

    setupSizeUpdating()
  }

  private func setupSizeUpdating() {
    disposeBag {
      framesListener.framesChanged
        .compactMap { [weak self] in self?.targetView?.frame.size }
        .startWith(.zero)
        .distinctUntilChanged { [axis] in $0.isEqual(to: $1, in: axis) }
        ==> { [weak self] in self?.updateSize($0) }
    }
  }

  private func updateSize(_ targetViewSize: CGSize) {
    layout = EmptyLayout().with(
      size: targetViewSize.insetBy(insets.negated)
    )

    invalidateIntrinsicContentSize()
  }
}


private extension CGSize {

  func isEqual(to that: CGSize,
               in axis: [NSLayoutConstraint.Axis]) -> Bool {
    let widthIsDifferent = axis.contains(.horizontal) && self.width != that.width
    let heightIsDifferent = axis.contains(.vertical) && self.height != that.height

    return !widthIsDifferent && !heightIsDifferent
  }
}
