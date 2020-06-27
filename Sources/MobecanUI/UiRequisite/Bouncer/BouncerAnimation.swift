//  Copyright © 2020 Mobecan. All rights reserved.


import RxSwift
import SwiftDateTime
import UIKit


class BouncerAnimation {
  
  private(set) lazy var offset: Observable<CGFloat> = privateOffset.asObservable()
  private var privateOffset = PublishSubject<CGFloat>()

  private let startOffset: CGFloat
  private let endOffset: CGFloat
  private let initialVelocity: CGFloat
  private let duration: Duration

  private let curve: Curve

  private var displayLink: CADisplayLink?
  private var startTime: Date?
  
  init(startOffset: CGFloat,
       endOffset: CGFloat,
       initialVelocity: CGFloat,
       duration: Duration) {
    self.startOffset = startOffset
    self.endOffset = endOffset
    self.initialVelocity = initialVelocity
    self.duration = duration

    self.curve = ReverseExponentCurve(
      attenuationRate: initialVelocity / (endOffset - startOffset)
    )
    
    displayLink = CADisplayLink(target: self, selector: #selector(tick))
  }
  
  func run() {
    privateOffset.onNext(startOffset)
    
    startTime = Date()
    displayLink?.add(to: RunLoop.main, forMode: .default)
  }
  
  @objc
  private func tick() {
    let curvedProgress = curve.y(x: progress)
    
    let newOffset = curvedProgress == 0 ?
      startOffset :
      curvedProgress == 1 ?
      endOffset :
      (endOffset * curvedProgress + startOffset * (1 - curvedProgress))

    privateOffset.on(.next(newOffset))
    
    if progress >= 1 { stop() }
  }
  
  private var progress: CGFloat {
    return startTime
      .map { Date().timeIntervalSince($0) / duration.toTimeInterval }
      .map { CGFloat($0).clipped(inside: 0...1) }
      ?? 0
  }
  
  func abort() {
    displayLink?.invalidate()
    
    DispatchQueue.main.async { [weak self] in self?.privateOffset.on(.completed) }
  }
  
  private func stop() {
    displayLink?.invalidate()
    
    DispatchQueue.main.async { [weak self] in self?.privateOffset.on(.completed) }
  }
}


private protocol Curve {
  
  func y(x: CGFloat) -> CGFloat // swiftlint:disable:this identifier_name
}


private struct LinearCurve: Curve {
  
  func y(x: CGFloat) -> CGFloat { return x } // swiftlint:disable:this identifier_name
}


private struct ReverseExponentCurve: Curve {

  let attenuationRate: CGFloat

  func y(x: CGFloat) -> CGFloat { // swiftlint:disable:this identifier_name
    
    guard x != 1 else { return 1 }
    
    let unsafeY = 1 - cos(0.5 * .pi * x) * exp(-attenuationRate * x)
    
    return unsafeY.clipped(inside: 0...1)
  }
}


private struct SineCurve: Curve {
  
  func y(x: CGFloat) -> CGFloat { // swiftlint:disable:this identifier_name
    let safeX = (x - 0.5) * .pi
    
    let unsafeY = 0.5 * (sin(safeX) + 1)
    
    return unsafeY.clipped(inside: 0...1)
  }
}
