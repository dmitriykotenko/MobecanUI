//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import UIKit
import CoreGraphics


/// Scrollable view which automatically changes its height
/// depending on content, safe area insets and keyboard frame.
public class ScrollableView: UIView, UIScrollViewDelegate {

  public let scrollView: UIScrollView

  /// Bottom-right counterpart of UIScrollView.contentOffset property.
  ///
  /// Horizontal and vertical distance
  /// between scroll view's visible area bottom-right corner and scroll view content's bottom-right corner.
  open var oppositeContentOffset: Observable<CGPoint> { oppositeContentOffsetTracker.value }

  @RxOutput private var adjustedContentInsetDidChange: Observable<Void>

  private lazy var oppositeContentOffsetTracker = RxScrollViewOppositeContentOffset(
    scrollView: scrollView,
    adjustedContentInsetDidChange: adjustedContentInsetDidChange
  )

  private let contentView: UIView
  private let middleman: ScrollViewMiddlemanView
  private let insetsCalculator: ScrollViewContentInsetsCalculator

  private var contentInsets: UIEdgeInsets = .zero

  private let disposeBag = DisposeBag()

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(contentView: UIView,
              scrollView: () -> UIScrollView) {
    self.contentView = contentView
    self.scrollView = scrollView()

    self.middleman = .init(contentView: contentView)
    self.insetsCalculator = .init(scrollView: scrollView())

    super.init(frame: .zero)

    setupScrollView()
    addSubviews()

    setupInsetsCalculator()
    setupLayout()
  }

  private func setupScrollView() {
    scrollView.contentInsetAdjustmentBehavior = .never
    scrollView.alwaysBounceVertical = false
    scrollView.delegate = self
  }

  private func addSubviews() {
    addSubview(scrollView)
    scrollView.addSubview(middleman)
  }

  private func setupInsetsCalculator() {
    disposeBag {
      rx.window
        .delay(0.milliseconds, scheduler: MainScheduler.instance) // wait until superview finishes its layout
        .whenNotEqual(to: nil)
        .do(onNext: { [weak self] in print("scroll-view-driver window = \(String(describing: self?.window))") })
        .compactMap { [weak self] in self?.longTermBottomY }
        .bind(to: insetsCalculator.scrollViewBottomY)
    }
  }

  private func setupLayout() {
    disposeBag {
      insetsCalculator.contentInsets ==> { [weak self] in
        self?.updateContentInsets(desiredInsets: $0)
      }
    }
  }

  private func updateContentInsets(desiredInsets: UIEdgeInsets) {
    print(">>> contentInsets: \(desiredInsets)")

    contentInsets = desiredInsets

    setNeedsLayoutAndPropagate()
  }

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    let middlemanSize = middleman.sizeThatFits(
      .init(
        width: size.width - (contentInsets.left + contentInsets.right),
        height: CGFloat.greatestFiniteMagnitude
      )
    )

    let totalHeight = middlemanSize.height + (contentInsets.top + contentInsets.bottom)

    return CGSize(
      width: size.width,
      height: min(size.height, totalHeight)
    )
  }

  override open func layoutSubviews() {
    addSubview(scrollView)

    let contentSize = middleman.sizeThatFits(
      .init(
        width: bounds.width - (contentInsets.left + contentInsets.right),
        height: CGFloat.greatestFiniteMagnitude
      )
    )

    scrollView.frame = self.bounds

    scrollView.contentSize = contentSize
    scrollView.scrollIndicatorInsets = contentInsets
    scrollView.contentInset = contentInsets

    middleman.frame = .init(
      x: 0,
      y: 0,
      width: contentSize.width,
      height: contentSize.height
    )
  }

  // MARK: - Scroll View Delegate

  open func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
    _adjustedContentInsetDidChange.onNext(())
  }
}
