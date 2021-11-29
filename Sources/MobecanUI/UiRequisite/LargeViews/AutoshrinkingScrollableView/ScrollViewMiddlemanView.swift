//  Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import UIKit
import LayoutKit


class ScrollViewMiddlemanView: UIView, LayoutInvalidationPropagator {

  override var frame: CGRect { didSet { _widthChanged.onNext(frame.width) } }
  override var bounds: CGRect { didSet { _widthChanged.onNext(bounds.width) } }

  @RxOutput(.zero) var desiredContentSize: Observable<CGSize>

  @RxOutput private var contentLayoutChanged: Observable<Void>
  @RxOutput private var widthChanged: Observable<CGFloat>

  private let contentView: UIView

  private let disposeBag = DisposeBag()

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  init(contentView: UIView) {
    self.contentView = contentView

    super.init(frame: .zero)

    addSubview(contentView)

    disposeBag {
      _desiredContentSize <==
        Observable
        .combineLatest(contentLayoutChanged.startWith(()), widthChanged.distinctUntilChanged())
          .compactMap { [weak contentView] _, width in
            contentView?.sizeThatFits(
              .init(width: width, height: CGFloat.greatestFiniteMagnitude)
            )[\.width, width]
          }
          .debug("middleman-desired-content-size")
    }
  }

  override func layoutSubviews() {
    contentView.frame = self.bounds
  }

  func subviewDidInvalidateLayout(subview: UIView) {
    _contentLayoutChanged.onNext(())
  }
}
