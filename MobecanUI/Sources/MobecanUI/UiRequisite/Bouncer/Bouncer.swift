//  Copyright © 2020 Mobecan. All rights reserved.


import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import SwiftDateTime
import UIKit


public class Bouncer {

  // MARK: - Inputs and outputs
  @RxUiInput([0]) public var attractors: AnyObserver<[CGFloat]>
  @RxUiInput(0) public var attractor: AnyObserver<CGFloat>
  @RxUiInput(false) public var areAnimationsEnabled: AnyObserver<Bool>

  @RxOutput(0) public var offset: Observable<CGFloat>
  @RxOutput(0) public var currentAttractor: Observable<CGFloat>
  @RxOutput(0) public var nextAttractor: Observable<CGFloat>

  // MARK: - Private properties
  private let axis: NSLayoutConstraint.Axis

  private let panContainer: UIView
  private let pan: Observable<UIPanGestureRecognizer>
  
  private lazy var panBounds = _attractors.map { $0[0]...$0[$0.count - 1] }
  
  private let animationDuration: Duration

  private lazy var panVelocity = pan
    .when(.began, .changed, .ended, .failed, .cancelled)
    .velocity(in: panContainer, axis: axis)
    .startWith(0)
  
  private lazy var currentState = Observable
    .combineLatest(_attractors, currentAttractor, offset, panVelocity) {
      CurrentState(attractors: $0, currentAttractor: $1, offset: $2, velocity: $3)
    }
  
  private var animation: BouncerAnimation?

  private let disposeBag = DisposeBag()
  
  // MARK: - Initialization
  public init(axis: NSLayoutConstraint.Axis,
              panContainer: UIView,
              pan: PanControlEvent? = nil,
              animationDuration: Duration,
              attractors: [CGFloat] = [-20, 150]) {
    self.axis = axis
    self.panContainer = panContainer
    
    let terminatingPan = pan ?? panContainer.rx.exclusivePan(axis: axis)
    // We do not need .complete event of pan gesture.
    self.pan = terminatingPan.asObservable().neverEnding()
    
    self.animationDuration = animationDuration
    
    self.attractors.onNext(attractors)
    
    setupAttraction()
    setupScrolling()
    
    setupManualAttractorChange()
    changeAttractorWhenPanEnded()
    changeAttractorWhenAttractorsListChanged()
    
    _offset.onNext(attractors[0])
    _currentAttractor.onNext(attractors[0])
  }
  
  private func setupManualAttractorChange() {
    let attractorChanged = _attractor
      .filterWithLatestFrom(currentAttractor) { $0 != $1 }
      .filterWithNot(pan.isInProgress)

    attractorChanged.bind(to: _nextAttractor).disposed(by: disposeBag)
  }
  
  private func changeAttractorWhenPanEnded() {
    pan.when(.ended)
      .withLatestFrom(currentState)
      .map { [weak self] in self?.selectNextAttractor(currentState: $0) ?? 0 }
      .bind(to: _nextAttractor)
      .disposed(by: disposeBag)
  }
  
  private func changeAttractorWhenAttractorsListChanged() {
    _attractors
      .distinctUntilChanged()
      .withLatestFrom(currentState)
      .map { [weak self] in self?.selectNextAttractor(currentState: $0) ?? 0 }
      .bind(to: _nextAttractor)
      .disposed(by: disposeBag)
  }
  
  private func selectNextAttractor(currentState: CurrentState) -> CGFloat {
    let attractors = currentState.attractors
    
    if currentState.velocity > 0 {
      return attractors.first { $0 > currentState.offset } ?? attractors[attractors.count - 1]
    } else if currentState.velocity < 0 {
      return attractors.last { $0 < currentState.offset } ?? attractors[0]
    } else {
      return attractors.first { abs($0 - currentState.offset) < 1 } ?? attractors[0]
    }
  }

  private func setupAttraction() {
    let attractorChange = nextAttractor
      .skip(1)
      .withLatestFrom(currentState) { (next: $0, current: $1) }
      .withLatestFrom(_areAnimationsEnabled) {
        AttractorChange(currentState: $0.current, nextAttractor: $0.next, animating: $1)
      }
    
    attractorChange
      .do(onNext: { [weak self] _ in self?.animation?.abort() })
      .flatMapLatest { [weak self] change in
        (self?.offsetChange(attractorChange: change) ?? .never())
          .do(onCompleted: { self?._currentAttractor.onNext(change.nextAttractor) })
      }
      .clippedWith(bounds: panBounds)
      .bind(to: _offset)
      .disposed(by: disposeBag)
  }
  
  private func offsetChange(attractorChange change: AttractorChange) -> Observable<CGFloat> {
    let distance = abs(change.nextAttractor - change.currentState.offset)
    
    switch (distance, change.animating) {
    case (0, _):
      return .empty()
    case (_, false):
      return .just(change.nextAttractor)
    case (_, true):
      return animatedOffsetChange(attractorChange: change)
    }
  }
  
  private func animatedOffsetChange(attractorChange change: AttractorChange) -> Observable<CGFloat> {
    animation = BouncerAnimation(
      startOffset: change.currentState.offset,
      endOffset: change.nextAttractor,
      initialVelocity: change.currentState.velocity,
      duration: animationDuration
    )
    
    animation?.run()

    return animation?.offset ?? .never()
  }

  private func setupScrolling() {
    // FIXME: how to clip offset once panBounds changed?
    pan.when(.began, .changed)
      .offset(in: panContainer, axis: axis, attractor: currentAttractor, bounds: panBounds)
      .bind(to: _offset)
      .disposed(by: disposeBag)
  }
}


private extension Bouncer {

  struct AttractorChange {
    
    let currentState: CurrentState
    let nextAttractor: CGFloat
    let animating: Bool
  }
  
  struct CurrentState {
    
    let attractors: [CGFloat]
    let currentAttractor: CGFloat
    let offset: CGFloat
    let velocity: CGFloat
  }
}


private extension Observable where Element: UIPanGestureRecognizer {
  
  func offset(in view: UIView,
              axis: NSLayoutConstraint.Axis,
              attractor: Observable<CGFloat>,
              bounds: Observable<ClosedRange<CGFloat>>) -> Observable<CGFloat> {
    return
      map { $0.translation(in: view).component(for: axis) }
      .withLatestFrom(attractor) { translation, attractor in translation + attractor }
      .clippedWith(bounds: bounds)
  }
  
  func velocity(in view: UIView, axis: NSLayoutConstraint.Axis) -> Observable<CGFloat> {
    return map {
      $0.velocity(in: view).component(for: axis)
    }
  }
}


extension CGPoint {
  
  func component(for axis: NSLayoutConstraint.Axis) -> CGFloat {
    switch axis {
    case .horizontal:
      return x
    case .vertical:
      return y
    @unknown default:
      fatalError("NSLayoutConstraint.Axis \(axis) is not supported yet.")
    }
  }
}
