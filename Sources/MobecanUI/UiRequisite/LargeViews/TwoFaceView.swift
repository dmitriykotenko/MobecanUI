// Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit


public class TwoFaceView: LayoutableView {
  
  @RxUiInput(0) public var borderTop: AnyObserver<CGFloat>
  
  private let topFace: UIView
  private let bottomFace: UIView

  private lazy var twoFaceLayout = TwoFaceLayout(
    topChild: topFace.asLayout,
    bottomChild: bottomFace.asLayout
  )

  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public convenience init(topColor: UIColor, bottomColor: UIColor) {
    self.init(
      topFace: ClickThroughView().backgroundColor(topColor),
      bottomFace: ClickThroughView().backgroundColor(bottomColor)
    )
  }

  public init(topFace: UIView, bottomFace: UIView) {
    self.topFace = topFace
    self.bottomFace = bottomFace
    
    super.init()

    isClickThroughEnabled = true
    
    setupLayout()
    setupBorder()
  }
  
  private func setupLayout() {
    layout = twoFaceLayout
  }
  
  private func setupBorder() {
    disposeBag {
      _borderTop.distinctUntilChanged() ==> { [weak self] in
        self?.twoFaceLayout.borderTop = $0
        self?.setNeedsLayout()
      }
    }
  }
  
  public func bindTo(parentView: UIView,
                     scrollView: UIScrollView,
                     bottomView: UIView,
                     offset: CGFloat) {
    let framesListener = FramesListener(views: bottomView.andSuperviews(upTo: scrollView))

    disposeBag {
      borderTop <== Observable
        .merge(scrollView.rx.contentOffset.mapToVoid(), framesListener.framesChanged)
        .map { _ in bottomView.bounds }
        .map { parentView.convert($0, from: bottomView) }
        .map { $0.topSideCenter.y + offset }
    }
  }
}


private class TwoFaceLayout: BaseLayout<UIView>, ConfigurableLayout {

  public var borderTop: CGFloat = 0

  private let topChild: Layout
  private let bottomChild: Layout

  public init(topChild: Layout,
              bottomChild: Layout) {
    self.topChild = topChild
    self.bottomChild = bottomChild

    super.init(
      alignment: .fill,
      flexibility: .max,
      viewReuseId: nil,
      config: nil
    )
  }

  open func measurement(within maxSize: CGSize) -> LayoutMeasurement {
    LayoutMeasurement(
      layout: self,
      size:  maxSize,
      maxSize: maxSize,
      sublayouts: [
        topChild.measurement(within: maxSize[\.height, safeBorderTop]),
        topChild.measurement(within: maxSize[\.height, { $0 - self.safeBorderTop }])
      ]
    )
  }

  open func arrangement(within rect: CGRect,
                        measurement: LayoutMeasurement) -> LayoutArrangement {
    LayoutArrangement(
      layout: self,
      frame: rect,
      sublayouts: [
        measurement.sublayouts[0].arrangement(
          // Top child frame
          within: CGRect(
            origin: .zero,
            size: measurement.sublayouts[0].size
          )
        ),
        measurement.sublayouts[1].arrangement(
          // Bottom child frame
          within: CGRect(
            origin: .init(x: 0, y: safeBorderTop),
            size: measurement.sublayouts[1].size
          )
        )
      ]
    )
  }

  private var safeBorderTop: CGFloat { max(borderTop, 0) }
}


private extension CGSize {

  subscript<Value>(_ keyPath: WritableKeyPath<Self, Value>, _ value: Value) -> Self {
    var result = self
    result[keyPath: keyPath] = value
    return result
  }

  subscript<Value>(_ keyPath: WritableKeyPath<Self, Value>,
                   _ transform: @escaping (Value) -> Value) -> Self {
    var result = self
    result[keyPath: keyPath] = transform(result[keyPath: keyPath])
    return result
  }
}
