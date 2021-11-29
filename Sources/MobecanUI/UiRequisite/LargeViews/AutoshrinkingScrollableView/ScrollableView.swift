//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import UIKit


/// Scrollable view which automatically changes its height
/// depending on content, safe area insets and keyboard frame.
public class ScrollableView: UIView, UIScrollViewDelegate {

  override open var frame: CGRect { didSet { middleman.frame.size.width = frame.width } }
  override open var bounds: CGRect { didSet { middleman.frame.size.width = bounds.width } }

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

  private var contentSizeAndInsets: ContentSizeAndInsets = .zero

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
      Observable.combineLatest(
        middleman.desiredContentSize,
        insetsCalculator.contentInsets.asObservable()
      ) ==> { [weak self] in
        self?.updateLayout(desiredContentSize: $0, desiredInsets: $1)
      }
    }
  }

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    CGSize(
      width: contentSizeAndInsets.totalWidth,
      height: min(size.height, contentSizeAndInsets.totalHeight)
    )
  }

  override open func layoutSubviews() {
    addSubview(scrollView)

    let contentSize = contentSizeAndInsets.size
    let contentInsets = contentSizeAndInsets.insets

    scrollView.frame = self.bounds

    scrollView.contentSize = contentSize
    scrollView.scrollIndicatorInsets = contentInsets
    scrollView.contentInset = contentInsets

    middleman.frame = .init(
      x: contentInsets.left,
      y: contentInsets.top,
      width: contentSize.width,
      height: contentSize.height
    )
  }

  private func updateLayout(desiredContentSize: CGSize,
                            desiredInsets: UIEdgeInsets) {
    print(">>> contentSize: \(desiredContentSize)")
    print(">>> contentInsets: \(desiredInsets)")

    contentSizeAndInsets = .init(
      size: desiredContentSize,
      insets: desiredInsets
    )

    setNeedsLayout()
    superview?.subviewNeedsToLayout(subview: self)
  }

  // MARK: - Scroll View Delegate

  open func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
    _adjustedContentInsetDidChange.onNext(())
  }
}


private struct ContentSizeAndInsets {

  var size: CGSize
  var insets: UIEdgeInsets

  static let zero = ContentSizeAndInsets(
    size: .zero,
    insets: .zero
  )

  var totalWidth: CGFloat { size.width + insets.left + insets.right }
  var totalHeight: CGFloat { size.height + insets.top + insets.bottom }
}
