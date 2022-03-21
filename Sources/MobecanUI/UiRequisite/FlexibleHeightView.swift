// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import SwiftDateTime
import UIKit


public class FlexibleHeightView: UIView {
  
  @RxOutput public var switchingFinished: Observable<Void>

  @RxUiInput(false) public var areAnimationsEnabled: AnyObserver<Bool>
  @RxUiInput(nil) public var visibleSubview: AnyObserver<UIView?>
  
  public var layoutUpdater: UIView?
  private var currentVisibleView: UIView?
  private var height: Constraint?

  private let animationDuration: Duration
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(layoutUpdater: UIView? = nil,
              animationDuration: Duration = .systemAnimation,
              _ subviews: [UIView]) {
    self.layoutUpdater = layoutUpdater
    self.animationDuration = animationDuration
    
    super.init(frame: .zero)

    translatesAutoresizingMaskIntoConstraints = false
    
    addSubviews(subviews)
    setupSwitching()
    
    visibleSubview.onNext(subviews.first)
    areAnimationsEnabled.onNext(true)
  }
  
  public func addSubviews(_ subviews: [UIView]) {
    subviews.forEach(addNextSubview)
  }

  private func setupSwitching() {
    disposeBag {
      _visibleSubview
        .debug("Flexible-Height-View-Visible-Subview")
        .distinctUntilChanged()
        .filterNil()
        .withLatestFrom(_areAnimationsEnabled) { (subview: $0, animated: $1) }
        ==> { [weak self] in self?.show(subview: $0.subview, animated: $0.animated) }
    }
  }
  
  private func show(subview: UIView,
                    animated: Bool) {
    guard currentVisibleView != subview else {
      _switchingFinished.onNext(())
      return
    }
    
    let transformation = ViewTransformation(
      start: { [weak self] in self?.addIfNecessary(subview: subview) },
      body: { [weak self] in
        print("Flexible-Height-View-Animation-Body")
        self?.height?.deactivate()
        subview.snp.makeConstraints { self?.height = $0.height.equalToSuperview().constraint }

        self?.layoutUpdater?.setNeedsLayout()
        self?.layoutUpdater?.layoutIfNeeded()

        self?.currentVisibleView?.alpha = 0
        subview.alpha = 1
      },
      finish: { [weak self] finished in
        print("Flexible-Height-View-Animation-Finish-\(finished)")
        if finished {
          self?.currentVisibleView = subview
          self?._switchingFinished.onNext(())
        }
      },
      duration: animationDuration,
      animationOptions: .curveEaseInOut
    )
      
    transformation.run(animated: animated)
  }
  
  private func addNextSubview(_ subview: UIView) {
    print("Flexible-Height-View-Add-Next-Subview")
    guard subview.superview != self else { return }
    
    addSubview(subview)
    
    subview.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }
    
    print("Flexible-Height-View-Add-Next-Subview-Set-Alpha-0")
    subview.alpha = 0
  }
  
  private func addIfNecessary(subview: UIView) {
    addNextSubview(subview)
  }
}


public class ViewTransformation {
  
  let start: (() -> Void)?
  let body: () -> Void
  let finish: ((Bool) -> Void)?
  let duration: Duration
  let animationOptions: UIView.AnimationOptions
  
  public init(start: (() -> Void)? = nil,
              body: @escaping () -> Void,
              finish: ((Bool) -> Void)? = nil,
              duration: Duration,
              animationOptions: UIView.AnimationOptions = []) {
    self.start = start
    self.body = body
    self.finish = finish
    
    self.duration = duration
    self.animationOptions = animationOptions
  }
  
  public func run(animated: Bool) {
    start?()

    if animated {
      UIView.animate(
        withDuration: duration.toTimeInterval,
        delay: 0,
        options: animationOptions,
        animations: { [body] in body() },
        completion: { [finish] in finish?($0) }
      )
    } else {
      body()
      finish?(true)
    }
  }
}
