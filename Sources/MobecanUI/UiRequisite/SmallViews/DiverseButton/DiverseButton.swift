// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


open class DiverseButton: UIButton, SizableView {
  
  /// If non-zero, extends tap area outside button's frame (usually used for small buttons).
  open var tapInsets: UIEdgeInsets = .zero
  
  override open func point(inside point: CGPoint,
                           with event: UIEvent?) -> Bool {
    
    let extendedBounds = bounds.inset(by: tapInsets)
    
    return extendedBounds.contains(point)
  }
  
  open var colorsByState: [ButtonColorsState] = [] {
    didSet { updateColorsAndAlpha() }
  }
  
  open var alphasByState: [(state: UIControl.State, alpha: CGFloat)] = [] {
    didSet { updateColorsAndAlpha() }
  }

  override open var isEnabled: Bool { didSet { updateColorsAndAlpha() } }
  override open var isHighlighted: Bool { didSet { updateColorsAndAlpha() } }
  override open var isSelected: Bool { didSet { updateColorsAndAlpha() } }

  open var titleTransformer: (String?) -> (String?) = { $0 }

  open var sizer = ViewSizer()

  override open func setTitle(_ title: String?,
                              for state: UIControl.State) {
    super.setTitle(
      title.flatMap(titleTransformer),
      for: state
    )
  }
  
  private func updateColorsAndAlpha() {
    updateTitleColor()
    updateTintColor()
    updateBackgroundColor()
    updateBorderColor()
    updateShadowColor()
    updateAlpha()
  }
  
  private func updateTitleColor() {
    colorsByState.forEach {
      setTitleColor($0.colors.title, for: $0.state)
    }
  }
  
  private func updateTintColor() {
    colorFor(\.tint).map { tintColor = $0 }
  }
  
  private func updateBackgroundColor() {
    colorFor(\.background).map { backgroundColor = $0 }
  }

  private func updateBorderColor() {
    colorFor(\.border).map { layer.borderColor = $0.cgColor }
  }

  private func updateShadowColor() {
    colorFor(\.shadow).map { layer.shadowColor = $0.cgColor }
  }

  private func colorFor(_ keyPath: KeyPath<ButtonColors, UIColor?>) -> UIColor? {
    colorsByState
      .first { $0.state == state }
      .flatMap { $0.colors[keyPath: keyPath] }
  }
  
  private func updateAlpha() {
    let newAlpha = alphasByState
      .first { $0.state == state }
      .map { $0.alpha }
    
    newAlpha.map { self.alpha = $0 }
  }

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    sizer.sizeThatFits(
      size,
      nativeSizing: super.sizeThatFits
    )
  }
}
