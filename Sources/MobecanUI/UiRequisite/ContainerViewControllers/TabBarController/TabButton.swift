//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit

import RxSwift
import RxCocoa


public class TabButton: UIButton {
  
  public var tintColors: [(state: UIControl.State, color: UIColor)] = [] {
    didSet {
      updateColors()
    }
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

    tintColors = [
      (.normal, .black),
      (.highlighted, .red),
      (.selected, .blue),
      ([.selected, .highlighted], UIColor.blue.withBrightnessMultiplied(by: 0.8))
    ]
    
    updateColors()
  }
  
  private func updateColors() {
    updateTitleTintColors()
    updateImageTintColor()
  }
  
  private func updateTitleTintColors() {
    tintColors.forEach { state, color in
      setTitleColor(color, for: state)
    }
  }
  
  private func updateImageTintColor() {
    tintColors
      .first { $0.state == state }
      .map { self.tintColor = $0.color }
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
    return imageView?.image?.size
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
    return titleLabel.flatMap { label in
      label.text.flatMap { text in
        label.font.map { font in
          NSString(string: text).size(withAttributes: [.font: font])
        }
      }
    }
  }
}
