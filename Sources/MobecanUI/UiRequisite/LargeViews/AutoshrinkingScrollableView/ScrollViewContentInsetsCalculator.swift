//  Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import UIKit


class ScrollViewContentInsetsCalculator: NSObject {

  @RxDriverOutput(.zero) var contentInsets: Driver<UIEdgeInsets>

  @RxUiInput(0) var scrollViewBottomY: AnyObserver<CGFloat>

  private let contentInsetsListener: SafeAreaInsetsListener

  private let uniqueId = UUID().uuidString

  private let disposeBag = DisposeBag()

  init(scrollView: UIScrollView) {
    self.contentInsetsListener =
      scrollView.maximumSafeAreaInsetsListener(
        windowChanged: scrollView.rx.windowChanged
      )

    super.init()

    disposeBag {
      _contentInsets <==
        .combineLatest(
          contentInsetsListener.insets.asObservable(),
          keyboardInset.share(replay: 1, scope: .forever)
        ) {
          $0.with(bottom: max($0.bottom, $1))
        }
        .debug("content-insets-calculator---desired-insets")
    }
  }

  private var keyboardInset: Observable<CGFloat> {
    .combineLatest(keyboardFrame, _scrollViewBottomY) { [uniqueId] in
      print("Scroll-view-driver-\(uniqueId) keyboardFrame = \($0), scrollViewBottomY = \($1)")
      return max($1 - $0.minY, 0)
    }
  }

  private var keyboardFrame: Observable<CGRect> {
    let initialKeyboardFrame = CGRect(
      x: 0,
      y: UIScreen.main.bounds.height,
      width: 0,
      height: 0
    )

    return RxKeyboard.instance.frame
      .startWith(initialKeyboardFrame)
      .delay(.milliseconds(100))
      .asObservable()
  }
}
