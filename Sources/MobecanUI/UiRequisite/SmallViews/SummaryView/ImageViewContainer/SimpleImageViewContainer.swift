//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension ImageViewContainer {
  
  static func simple(imageView: UIImageView,
                     placeholder: UIImage,
                     placement: SimpleImageViewContainer.VerticalPlacement) -> ImageViewContainer {
    SimpleImageViewContainer(
      imageView: imageView,
      placeholder: placeholder,
      verticalPlacement: placement
    )
  }
}


open class SimpleImageViewContainer: ImageViewContainer {
  
  public enum VerticalPlacement {
    case center(CGFloat)
    case top(CGFloat)
    case bottom(CGFloat)
    case firstBaseline(CGFloat)
  }
  
  public let imageView: UIImageView
  public let containerView: UIView
  
  public let placeholder: UIImage?
  public let verticalPlacement: VerticalPlacement
  
  public init(imageView: UIImageView,
              placeholder: UIImage? = nil,
              verticalPlacement: VerticalPlacement) {
    self.imageView = imageView
    self.placeholder = placeholder
    self.verticalPlacement = verticalPlacement
    
    switch verticalPlacement {
    case .top(let offset):
      containerView = ClickThroughView.top(imageView, inset: offset)
    case .bottom(let offset):
      containerView = ClickThroughView.bottom(imageView, inset: offset)
    case .center(let offset):
      containerView = ClickThroughView.centeredVertically(imageView, offset: offset)
    case .firstBaseline(let offset):
      containerView = ClickThroughView.top(imageView, inset: offset, priority: .minimum)
    }
  }
  
  public func alignImage(inside superview: UIView) {
    switch verticalPlacement {
    case .firstBaseline(let offset):
      imageView.snp.makeConstraints { $0.bottom.equalTo(superview.snp.firstBaseline).offset(offset) }
    default:
      break
    }
  }
  
  public func display(image: Image?) {
    switch image {
    case .image(let image):
      imageView.image = image
    case .tintedImage(let image, let color):
      imageView.templateImage = image
      imageView.tintColor = color
    case .url(let url):
      imageView.kf.setImage(with: url, placeholder: placeholder)
    case nil:
      imageView.image = placeholder
    }
  }
}
