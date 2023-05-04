// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


/// Вьюшка с отверстиями, которые прозрачны для жестов.
open class HoleyView: UIView, SizableView {

  open var sizer = ViewSizer()

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    sizer.sizeThatFits(
      size,
      nativeSizing: super.sizeThatFits
    )
  }

  private let holes: [UIView]

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  /// Создаёт вьюшку с отверстиями, прозрачными для жестов.
  /// - Parameter holes: Вьюшки позади `HoleyView`, жесты в которых мы не хотим блокировать.
  public init(holes: [UIView]) {
    self.holes = holes
    
    super.init(frame: .zero)

    withStretchableSize()
  }
  
  override public func point(inside point: CGPoint,
                             with event: UIEvent?) -> Bool {
    let tappedHole = holes
      .lazy
      .filter {
        // Надо конвертировать `point` в систему координат отверстия,
        // потому что метод `UIView.point(inside:with:)` использует систему координат вьюшки,
        // у которой он вызывается.
        let convertedPoint = $0.convert(point, from: self)
        
        return $0.point(inside: convertedPoint, with: event)
      }
      .first
    
    if tappedHole != nil {
      return false
    } else {
      return super.point(inside: point, with: event)
    }
  }
}
