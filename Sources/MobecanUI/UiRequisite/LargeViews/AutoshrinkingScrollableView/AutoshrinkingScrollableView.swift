//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import UIKit


/// Scrollable view which automatically changes its height
/// depending on content, safe area insets and keyboard frame.
public class AutoshrinkingScrollableView: WindowListeningView {
  
  public let scrollView: UIScrollView
  
  private let contentView: UIView

  private lazy var scrollViewDriver = ScrollViewHeightDriver(
    scrollView: scrollView,
    contentView: contentView,
    scrollViewWindowChanged: windowChanged.asObservable()
  )

  private let disposeBag = DisposeBag()
    
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(contentView: UIView,
              scrollView: (UIView) -> UIScrollView) {
    self.contentView = contentView
    self.scrollView = scrollView(contentView)

    super.init(frame: .zero)

    // Set low-priority width to suppress autolayout warning.
    _ = width(0, priority: .minimum)

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
  }
}
