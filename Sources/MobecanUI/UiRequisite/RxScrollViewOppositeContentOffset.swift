// Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


/// Notifies about changes of .oppositeContentOffset property of UIScrollView.
public class RxScrollViewOppositeContentOffset {

  /// Current oppositeContentOffset.
  @RxOutput(.zero) public var value: Observable<CGPoint>
  
  private let contentSizeListener: NSKeyValueObservation

  private weak var scrollView: UIScrollView?

  private let disposeBag = DisposeBag()
  
  /// UIScrollView.adjustedContentInset is not KVO-compliant,
  /// so we need an explicit signal about inset change.
  ///
  /// We can get the signal e. g. via scroll view's delegate.
  public init(scrollView: UIScrollView,
              adjustedContentInsetDidChange: Observable<Void>) {
    self.scrollView = scrollView

    let contentSizeChanged = PublishRelay<Void>()
    contentSizeListener = scrollView.observe(\.contentSize, options: .initial) { _, _ in
      contentSizeChanged.accept(())
    }

    Observable
      .combineLatest(
        scrollView.rx.didScroll.startWith(()),
        contentSizeChanged.startWith(()),
        adjustedContentInsetDidChange.startWith(())
      )
      .compactMap { [weak self] _, _, _ in self?.scrollView?.oppositeContentOffset }
      .distinctUntilChanged()
      .bind(to: _value)
      .disposed(by: disposeBag)
  }
}
