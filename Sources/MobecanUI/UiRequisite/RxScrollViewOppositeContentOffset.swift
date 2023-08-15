// Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


/// Уведомляет об изменениях ``UIScrollView.oppositeContentOffset``.
public class RxScrollViewOppositeContentOffset {

  /// Текущий ``.oppositeContentOffset``.
  @RxOutput(.zero) public var value: Observable<CGPoint>
  
  private let contentSizeListener: NSKeyValueObservation

  private weak var scrollView: UIScrollView?

  private let disposeBag = DisposeBag()
  
  /// - Parameters:
  ///   - scrollView: Скролл-вью, чей ``.oppositeContentOffset`` надо отслеживать.
  ///   - adjustedContentInsetDidChange: Свойство ``UIScrollView.adjustedContentInset`` не поддерживает KVO,
  ///   поэтому необходим явный сигнал о том, что инсеты поменялись.
  ///   Например, этот сигнал можно взять у делегата ``UIScrollView``.
  public init(scrollView: UIScrollView,
              adjustedContentInsetDidChange: Observable<Void>) {
    self.scrollView = scrollView

    let contentSizeChanged = PublishRelay<Void>()
    contentSizeListener = scrollView.observe(\.contentSize, options: .initial) { _, _ in
      contentSizeChanged.accept(())
    }

    disposeBag {
      _value <== Observable
        .combineLatest(
          scrollView.rx.didScroll.startWith(()),
          contentSizeChanged.startWith(()),
          adjustedContentInsetDidChange.startWith(())
        )
        .compactMap { [weak self] _, _, _ in self?.scrollView?.oppositeContentOffset }
        .distinctUntilChanged()
    }
  }
}
