// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


open class BackgroundView: ClickThroughView, DataView {
  
  public typealias Value = ColorImageOrView
  @RxUiInput(nil) public var value: AnyObserver<ColorImageOrView?>

  private let imageView: UIImageView
  private let customViewContainer = ClickThroughView.autolayoutStretchableSpacer()
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(imageView: UIImageView) {
    self.imageView = imageView
    
    super.init(frame: .zero)
    
    addSubviews()
    displayValue()
  }
  
  private func addSubviews() {
    putSingleSubview(
      .zstack([imageView, customViewContainer])
    )
  }
  
  private func displayValue() {
    disposeBag {
      _value ==> { [weak self] in self?.displayValue($0) }
    }
  }
  
  private func displayValue(_ value: ColorImageOrView?) {
    switch value {
    case .color(let color):
      imageView.isVisible = false
      customViewContainer.isVisible = false
      backgroundColor = color
      customViewContainer.removeAllSubviews()
    case .image(let image):
      imageView.image = image
      imageView.isVisible = true
      customViewContainer.isVisible = false
      backgroundColor = nil
      customViewContainer.removeAllSubviews()
    case .view(let view):
      imageView.isVisible = false
      customViewContainer.isVisible = true
      backgroundColor = nil
      customViewContainer.putSingleSubview(view)
    case nil:
      imageView.isVisible = false
      customViewContainer.isVisible = false
      customViewContainer.removeAllSubviews()
    }
  }
}
