//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import UIKit


/// Changes scroll view's height when scroll view's content and safe area insets are changed
/// and when keyboard appears or disappears.
class ScrollViewHeightDriver: NSObject, UIScrollViewDelegate {

  private let uniqueId = UUID().uuidString
  
  @RxUiInput(0) var scrollViewBottomY: AnyObserver<CGFloat>

  private let scrollView: UIScrollView
  private let contentView: UIView

  private let contentInsetsListener: SafeAreaInsetsListener
  private let contentFrameListener: FramesListener

  @RxDriverOutput(0) private var keyboardInset: Driver<CGFloat>

  private var scrollViewHeight: Constraint?

  private let disposeBag = DisposeBag()
  
  init(scrollView: UIScrollView,
       contentView: UIView,
       scrollViewWindowChanged: Observable<Void>) {
    self.scrollView = scrollView
    self.contentView = contentView
    
    self.contentInsetsListener =
      scrollView.maximumSafeAreaInsetsListener(windowChanged: scrollViewWindowChanged)
    
    self.contentFrameListener = FramesListener(views: [contentView])

    super.init()
 
    scrollView.contentInsetAdjustmentBehavior = .never
    scrollView.alwaysBounceVertical = false
    
    setupInitialHeight()
    setupHeightUpdates()
    setupInteractionWithKeyboard()
  }
  
  private func setupInitialHeight() {
    scrollView.snp.makeConstraints {
      scrollViewHeight = $0.height.greaterThanOrEqualTo(0).priority(.high).constraint
    }
  }
  
  private func setupHeightUpdates() {
    let contentFrame = contentFrameListener.framesChanged
      .map { [weak self] in self?.contentView.frame }
      .filterNil()
      .asDriver(onErrorJustReturn: .zero)

    let keyboardAwareContentInsets = Driver
      .combineLatest(contentInsetsListener.insets, keyboardInset) { $0.with(bottom: max($0.bottom, $1)) }
    
    Driver
      .combineLatest(contentFrame, keyboardAwareContentInsets) { (contentFrame: $0, contentInsets: $1) }
      .distinctUntilChanged { $0.contentFrame.height == $1.contentFrame.height && $0.contentInsets == $1.contentInsets }
      .drive(onNext: { [weak self] in
        print(
          "Scroll-view-driver-\(String(describing: self?.uniqueId)) " +
          "content frame changed to \(String(describing: self?.contentView.frame))"
        )
        
        self?.updateMinimumHeight(contentInsets: $0.contentInsets)
      })
      .disposed(by: disposeBag)
  }
  
  private func updateMinimumHeight(contentInsets: UIEdgeInsets) {
    print("Scroll-view-driver-\(uniqueId) new content insets: \(contentInsets)")
    print("Scroll-view-driver-\(uniqueId) content view frame: \(contentView.frame)")
    
    scrollView.scrollIndicatorInsets = contentInsets
    scrollView.contentInset = contentInsets

    scrollViewHeight?.update(offset:
      contentView.frame.height + contentInsets.top + contentInsets.bottom
    )
    
    scrollView.superview?.layoutIfNeeded()
  }
  
  private func setupInteractionWithKeyboard() {
    let initialKeyboardFrame = CGRect(
      x: 0,
      y: UIScreen.main.bounds.height,
      width: 0,
      height: 0
    )
   
    Observable
      .combineLatest(
        RxKeyboard.instance.frame.startWith(initialKeyboardFrame).delay(.milliseconds(100)).asObservable(),
        _scrollViewBottomY
      )
      .map { [weak self] in self?.bottomInset(keyboardFrame: $0, scrollViewBottomY: $1) ?? .zero }
      .bind(to: _keyboardInset)
      .disposed(by: disposeBag)
  }
  
  private func bottomInset(keyboardFrame: CGRect,
                           scrollViewBottomY: CGFloat) -> CGFloat {
    print("Scroll-view-driver-\(uniqueId) keyboardFrame = \(keyboardFrame), scrollViewBottomY = \(scrollViewBottomY)")
    return max(scrollViewBottomY - keyboardFrame.minY, 0)
  }
}
