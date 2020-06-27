//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public class DiverseButton: UIButton {
  
  /// If non-zero, extends tap area outside button's frame (usually used for small buttons).
  public var tapInsets: UIEdgeInsets = .zero
  
  override public func point(inside point: CGPoint,
                             with event: UIEvent?) -> Bool {
    
    let extendedBounds = bounds.inset(by: tapInsets)
    
    return extendedBounds.contains(point)
  }
  
  public var colorsByState: [ButtonColorsState] = [] {
    didSet { updateColorsAndAlpha() }
  }
  
  public var alphasByState: [(state: UIControl.State, alpha: CGFloat)] = [] {
    didSet { updateColorsAndAlpha() }
  }
  
  override public var isEnabled: Bool { didSet { updateColorsAndAlpha() } }
  override public var isHighlighted: Bool { didSet { updateColorsAndAlpha() } }
  override public var isSelected: Bool { didSet { updateColorsAndAlpha() } }
  
  private func updateColorsAndAlpha() {
    updateTitleColor()
    updateTintColor()
    updateBackgroundColor()
    updateShadowColor()
    updateAlpha()
  }
  
  private func updateTitleColor() {
    colorsByState.forEach {
      setTitleColor($0.colors.title, for: $0.state)
    }
  }
  
  private func updateTintColor() {
    let newTintColor = colorsByState
      .first { $0.state == state }
      .map { $0.colors.tint }
    
    newTintColor.map { self.tintColor = $0 }
  }
  
  private func updateBackgroundColor() {
    let newBackgroundColor = colorsByState
      .first { $0.state == state }
      .map { $0.colors.background }
    
    newBackgroundColor.map { self.backgroundColor = $0 }
  }
  
  private func updateShadowColor() {
    let newShadowColor = colorsByState
      .first { $0.state == state }
      .map { $0.colors.shadow }
    
    newShadowColor.map { self.layer.shadowColor = $0?.cgColor }
  }
  
  private func updateAlpha() {
    let newAlpha = alphasByState
      .first { $0.state == state }
      .map { $0.alpha }
    
    newAlpha.map { self.alpha = $0 }
  }
}
