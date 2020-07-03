//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit

import RxSwift
import RxCocoa


public class TabButton: UIButton {
  
  public var colorsByState: [ButtonColorsState] = [] {
    didSet { updateColors() }
  }
  
  override open var isEnabled: Bool { didSet { updateColors() } }
  override open var isHighlighted: Bool { didSet { updateColors() } }
  override open var isSelected: Bool { didSet { updateColors() } }
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(title: String? = nil,
              image: UIImage? = nil,
              textStyle: TextStyle,
              spacing: CGFloat,
              insets: UIEdgeInsets) {
    
    super.init(frame: .zero)
    
    contentEdgeInsets = insets

    _ = self.textStyle(textStyle)
    setTitle(title, for: UIControl.State.normal)

    setImage(
      image?.withRenderingMode(.alwaysTemplate),
      for: UIControl.State.normal
    )
    adjustsImageWhenHighlighted = false

    placeTitleBelowImage(spacing: spacing)

    colorsByState = [
      .normal(title: .black, tint: .black),
      .highlighted(title: .red, tint: .red),
      .selected(title: .blue, tint: .blue),
      .init(
        state: [.selected, .highlighted],
        colors: .init(
          title: UIColor.blue.withBrightnessMultiplied(by: 0.8),
          tint: UIColor.blue.withBrightnessMultiplied(by: 0.8)
        )
      )
    ]
    
    updateColors()
  }
  
  private func updateColors() {
    updateTitleColor()
    updateTintColor()
    updateBackgroundColor()
    updateShadowColor()
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

  override open var frame: CGRect { didSet { placeTitleBelowImage() } }
  override open var bounds: CGRect { didSet { placeTitleBelowImage() } }
}


private extension TabButton {
  
  func placeTitleBelowImage(spacing: CGFloat = 0) {
    adjustTitlePosition(spacing)
    adjustImagePosition(spacing)
  }
  
  private func adjustTitlePosition(_ spacing: CGFloat) {
    guard let imageSize = currentImageSize else { return }
    
    titleEdgeInsets = UIEdgeInsets(
      top: spacing,
      left: -imageSize.width,
      bottom: -imageSize.height,
      right: 0.0
    )
  }
  
  private var currentImageSize: CGSize? {
    imageView?.image?.size
  }
  
  private func adjustImagePosition(_ spacing: CGFloat) {
    guard let titleSize = currentTitleSize else { return }
    
    imageEdgeInsets = UIEdgeInsets(
      top: -(titleSize.height + spacing),
      left: 0.0,
      bottom: 0.0,
      right: -titleSize.width
    )
  }
  
  private var currentTitleSize: CGSize? {
    titleLabel.flatMap { label in
      label.text.flatMap { text in
        label.font.map { font in
          NSString(string: text).size(withAttributes: [.font: font])
        }
      }
    }
  }
}
