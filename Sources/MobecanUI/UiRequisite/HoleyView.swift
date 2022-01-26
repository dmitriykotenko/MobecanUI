// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


/// View with holes which are transparent for gestures.
public class HoleyView: UIView {
  
  private let holes: [UIView]

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(holes: [UIView]) {
    self.holes = holes
    
    super.init(frame: .zero)
  }
  
  override public func point(inside point: CGPoint,
                             with event: UIEvent?) -> Bool {
    let tappedHole = holes
      .lazy
      .filter {
        // We must convert point to hole's coordinate system,
        // because `point(inside:with:)` method uses view's local coordinate system.
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
