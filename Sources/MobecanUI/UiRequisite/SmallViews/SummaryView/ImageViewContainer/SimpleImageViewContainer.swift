//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension ImageViewContainer {
  
  static func simple(imageView: UIImageView,
                     placeholder: UIImage? = nil,
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
    case center
    case top(CGFloat)
    case bottom(CGFloat)
  }
  
  public let placeholder: UIImage?
  public let verticalPlacement: VerticalPlacement
  
  public init(imageView: UIImageView,
              placeholder: UIImage? = nil,
              verticalPlacement: VerticalPlacement) {
    self.placeholder = placeholder
    self.verticalPlacement = verticalPlacement
    
    super.init(
      imageView: imageView,
      containerView: SimpleImageViewContainer.containerView(
        imageView,
        verticalPlacement: verticalPlacement
      )
    )
  }
  
  private static func containerView(_ imageView: UIImageView,
                                    verticalPlacement: VerticalPlacement) -> UIView {
    switch verticalPlacement {
    case .top(let inset):
      return LayoutableView(
        layout: imageView.withAlignment(.topFill).withInsets(.top(inset))
      )
    case .bottom(let inset):
      return LayoutableView(
        layout: imageView.withAlignment(.bottomFill).withInsets(.bottom(inset))
      )
    case .center:
      return LayoutableView(
        layout: imageView.withAlignment(.centerFill)
      )
    }
  }
  
  override open func display(image: Image?) {
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
