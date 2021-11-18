//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import UIKit


/// Scrollable view which automatically changes its height
/// depending on content, safe area insets and keyboard frame.
public class AutoshrinkingScrollableView: WindowListeningView, UIScrollViewDelegate {

  public let scrollView: UIScrollView

  /// Bottom-right counterpart of UIScrollView.contentOffset property.
  ///
  /// Horizontal and vertical distance
  /// between scroll view's visible area bottom-right corner and scroll view content's bottom-right corner.
  open var oppositeContentOffset: Observable<CGPoint> { oppositeContentOffsetTracker.value }

  private let contentView: UIView

  private lazy var scrollViewDriver = ScrollViewHeightDriver(
    scrollView: scrollView,
    contentView: contentView,
    scrollViewWindowChanged: windowChanged.asObservable()
  )

  @RxOutput private var adjustedContentInsetDidChange: Observable<Void>

  private lazy var oppositeContentOffsetTracker = RxScrollViewOppositeContentOffset(
    scrollView: scrollView,
    adjustedContentInsetDidChange: adjustedContentInsetDidChange
  )

  private let disposeBag = DisposeBag()

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(contentView: UIView,
              scrollView: (UIView) -> UIScrollView) {
    self.contentView = contentView
    self.scrollView = scrollView(contentView)

    super.init(frame: .zero)
//
//    // Set low-priority width to suppress autolayout warning.
//    _ = width(0, priority: .minimum)

    self.scrollView.contentInsetAdjustmentBehavior = .never
    self.scrollView.alwaysBounceVertical = false

    putSubview(self.scrollView)

    // To disable horizontal scrolling, bind contentView's width to autoshrinking scrollable view's width.
    self.contentView.snp.makeConstraints {
      $0.width.equalTo(self)
    }

    self.windowChanged
      .delay(0.milliseconds) // wait until superview finishes its layout
      .filter { [weak self] in self?.window != nil }
      .do(onNext: { [weak self] in print("scroll-view-driver window = \(String(describing: self?.window))") })
      .compactMap { [weak self] in self?.longTermBottomY }
      .emit(to: scrollViewDriver.scrollViewBottomY)
      .disposed(by: disposeBag)

    self.scrollView.delegate = self
  }

  // MARK: - Scroll View Delegate

  open func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
    _adjustedContentInsetDidChange.onNext(())
  }
}
