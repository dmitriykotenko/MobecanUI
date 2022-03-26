// Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit


open class ReactiveSpacerView: LayoutableView {

  /// Какую область вьюшки надо учитывать при вычислении размера.
  public enum Coverage {

    /// При вычислении размера надо учитывать всю вьюшку.
    case wholeView

    /// При вычислении размера надо учитывать ту часть вьюшки,
    /// которая лежит внутри safeArea родительского вью-контроллера.
    case safeArea
  }
  
  private weak var targetView: UIView?
  private let axis: [NSLayoutConstraint.Axis]
  private let coverage: Coverage
  private let insets: UIEdgeInsets

  private let framesListener: FramesListener
  private let safeAreaInsetsListener: SafeAreaInsetsListener?

  private let disposeBag = DisposeBag()

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(targetView: UIView,
              axis: [NSLayoutConstraint.Axis],
              coverage: Coverage,
              insets: UIEdgeInsets) {
    self.targetView = targetView
    self.axis = axis
    self.coverage = coverage
    self.insets = insets
    
    self.framesListener = FramesListener(views: [targetView])

    switch coverage {
    case .wholeView:
      self.safeAreaInsetsListener = nil
    case .safeArea:
      self.safeAreaInsetsListener = .init(
        view: targetView,
        windowChanged: targetView.rx.windowChanged,
        transform: { .zero }
      )
    }

    super.init()

    self.layout = EmptyLayout().with(size: .zero)

    setupSizeUpdating()
  }

  private func setupSizeUpdating() {
    disposeBag {
      needToUpdateSize
        .compactMap { [weak targetView, coverage] in targetView?.coveredSize(coverage: coverage) }
        .startWith(.zero)
        .distinctUntilChanged { [axis] in $0.isEqual(to: $1, in: axis) }
        ==> { [weak self] in self?.updateSize($0) }
    }
  }

  private var needToUpdateSize: Observable<Void> {
    .merge(
      framesListener.framesChanged,
      safeAreaInsetsListener?.insets.asObservable().mapToVoid() ?? .empty()
    )
  }

  private func updateSize(_ targetViewSize: CGSize) {
    layout = EmptyLayout().with(
      size: targetViewSize.insetBy(insets.negated)
    )

    invalidateIntrinsicContentSize()
  }
}


private extension UIView {

  func coveredSize(coverage: ReactiveSpacerView.Coverage) -> CGSize {
    switch coverage {
    case .wholeView:
      return frame.size
    case .safeArea:
      return frame.size.insetBy(safeAreaInsets)
    }
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
